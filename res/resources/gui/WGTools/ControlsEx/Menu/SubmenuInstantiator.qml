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
		if (object.item) {
			var newIndex = startIndex + index
			if (object.isMenu) {
				menu.insertMenu(newIndex, object.item)
				var menuItem = menu.itemAt(newIndex)
				var submenu = menu.menuAt(newIndex)
				if (object.icon.length > 0) {
					menuItem.icon.source = "image://gui/" + object.icon
					menuItem.icon.color = "transparent"
				}
				menuItem.visible = Qt.binding(function() { return submenu.count > 0 })
			}
			else {
				menu.insertItem(newIndex, object.item)
			}
		}
	}

	onObjectRemoved: {
		if (object.item) {
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
			property string icon: ""

			Component.onCompleted: {
				if (item != null) {
					return
				}

				var modelIndex = delegateModel.modelIndex(index)

				if (!model.isValid) {
					item = menuInvalidItemComponent.createObject(parent)
				}
				else if (model.isAction) {
					item = menuItemComponent.createObject(parent)
				}
				else if (model.isSeparator) {
					item = menuSeparatorComponent.createObject(parent)
				}
				else if (model.isContainer) {
					var component = Qt.createComponent("Submenu.qml")

					item = component.createObject(parent, {
						"menuModel": instantiator.menuModel,
						"rootIndex": modelIndex,
						"title": model.itemName})

					isMenu = true
					icon = model.itemIcon
				}
			}

			readonly property Component __itemComponent: Component {
				id: menuItemComponent
				MenuItem {
					display: AbstractButton.TextBesideIcon
					icon.source: model.itemIcon.length > 0 ? "image://gui/" + model.itemIcon : ""
					icon.color: "transparent"
					text: model.itemName
					checkable: model.action.checkable
					checked: model.action.checked
					enabled: model.action.enabled
					onTriggered: Qt.callLater(function(){model.action.execute()})
				}
			}

			readonly property Component __invalidItemComponent: Component {
				id: menuInvalidItemComponent
				MenuItem {
					text: "<Unknown Action>"
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
