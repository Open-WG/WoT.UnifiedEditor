import QtQuick 2.11
import QtQml.Models 2.11
import WGTools.Controls 2.0

Instantiator {
	id: instantiator
	
	property var menu: null
	property var menuModel: null
	property var rootIndex: null

	onObjectAdded: {
		if (object.item) {
			if (object.isMenu) {
				menu.insertMenu(index, object.item)
			} else {
				menu.insertItem(index, object.item)
			}
		}
	}

	onObjectRemoved: {
		if (object.item) {
			if(object.isMenu) {
				menu.removeMenu(object.item)
			} else {
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

				if (numChildren == 0) {
					item = menuItemComponent.createObject(menu)
				} else {
					var component = Qt.createComponent("AddTrackMenu.qml")

					item = component.createObject(menu, {
						"menuModel": instantiator.menuModel,
						"rootIndex": modelIndex,
						"title": model.popupData.label})

					isMenu = true
				}
			}
			
			readonly property Component __component: Component {
				id: menuItemComponent

				AddTrackMenuItem {
					text: model.popupData.label
					visible: model.popupData.visible

					icon.source: model.popupData.icon

					onTriggered: {
						model.popupData.triggered();
						menuModel.triggered(delegateModel.modelIndex(index))
					}
				}
			}
		}
	}
}
