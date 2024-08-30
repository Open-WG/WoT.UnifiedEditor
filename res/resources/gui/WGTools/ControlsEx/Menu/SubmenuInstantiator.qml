import QtQuick 2.11
import QtQml.Models 2.11
import WGTools.Controls 2.0

Instantiator {
	id: instantiator
	property var menu: null
	property var startIndex: 0
	property var menuModel: null
	property var rootIndex: null

	onObjectAdded: {

		if (object.item)
		{
			if (object.isMenu) {
				menu.insertMenu(startIndex + index, object.item)
			}
			else{
				menu.insertItem(startIndex + index, object.item)
			}
		}
	}

	onObjectRemoved: {

		if (object.item)
		{
			if (object.isMenu) {
				menu.removeMenu(object.item)
			}
			else{
				menu.removeItem(object.item)
			}
		}
	}

	model: DelegateModel {

		id: delegateModel

		model: instantiator.menuModel
		rootIndex: instantiator.rootIndex

		delegate: QtObject {
			property var item: null
			property var isMenu: false

			Component.onCompleted: {
				if (item != null) {
					return
				}

				var modelIndex = delegateModel.modelIndex(index)
				var numChildren = delegateModel.model.rowCount(modelIndex)

				if (!model.isValid) {
					item = menuInvalidItemComponent.createObject(parent)
				}
				else if (model.isAction) {
					item = menuItemComponent.createObject(parent)
				}
				else if (model.isSeparator) {
					item = menuSeparatorComponent.createObject(parent)
				}
				else if (model.isContainer && numChildren > 0) {
					var component = Qt.createComponent("Submenu.qml")

					item = component.createObject(parent, {
						"menuModel": instantiator.menuModel,
						"rootIndex": modelIndex,
						"title": model.itemName})

					isMenu = true
				}
			}

			readonly property Component __itemComponent: Component {
				id: menuItemComponent
				MenuItem {
					text: model.itemName
					checkable: model.action.checkable
					checked: model.action.checked
					enabled: model.action.enabled
					onTriggered: model.action.execute()
				}
			}

			readonly property Component __invalidItemComponent: Component {
				id: menuInvalidItemComponent
				MenuItem {
					text: "???"
					enabled: false
				}
			}

			readonly property Component __separatorComponent: Component {
				id: menuSeparatorComponent
				MenuSeparator {
					width: menu.width
				}
			}

		}
	}
}
