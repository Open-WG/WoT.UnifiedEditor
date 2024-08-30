import QtQuick 2.7
import QtQuick.Controls 1.4
import WGTools.Views 1.0 as Views
import WGTools.Controls 1.0 as Controls
import QtQml.Models 2.2

// Currently has just checkable functionality (depends on 'checked' role)
// TODO: make exposed class with ability to invoke action
Controls.Menu {
	id: menu
	property var model: null
	property var rootIndex: null
	
	DelegateModel {
		id: delegateModel
		model: context.menuModel
		rootIndex: menu.rootIndex

		delegate: QtObject {
			property var item: null

			Component.onCompleted: {
				timer.start()
			}

			Component.onDestruction: {
				if (item != null) {
					menu.removeItem(item)
				}
			}

			readonly property Timer __timer: Timer {
				id: timer
				interval: 0
				onTriggered: {
					populate();
				}
			}

			function populate() {
				if (item != null) {
					return
				}
				var modelIndex = delegateModel.modelIndex(index)
				var numChildren = delegateModel.model.rowCount(modelIndex)

				if (numChildren == 0) {
					item = menuItemComponent.createObject(menu)
				} else {
					var component = Qt.createComponent("MenuView.qml")
					item = component.createObject(menu, {"model": model, "rootIndex": modelIndex, "title": model.name, "isSubMenu": true})
				}

				menu.insertItem(menu.items.length, item)
			}

			readonly property Component __component: Component {
				id: menuItemComponent

				Controls.MenuItem {
					id: menuItem
					text: model.name
					checkable: true

					// TODO: make normal 2-side binding
					onCheckedChanged: {
						model.checked = checked
					}

					Component.onCompleted: {
						checked = model.checked
					}
				}
			}
		}
	}

	Instantiator {
		model: delegateModel
	}
}
