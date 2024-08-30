import QtQuick 2.10
import WGTools.Controls 2.0
import WGTools.Utils 1.0

QtObject {
	property var propertyGrid

	function canShowMenu() {
		return propertyGrid && propertyGrid.selection && propertyGrid.selection.hasSelection
	}

	function showMenu(mouseX, mouseY) {
		let menu = propertyGrid.contextMenu.createObject(propertyGrid)
		Utils.iterateChildrenAt(propertyGrid.rootGroup, mouseX, mouseY, function(item) {
			if (item.hasOwnProperty("extendContextMenu")) {
				item.extendContextMenu(menu)
				return true
			}

			return false
		})

		menu.closed.connect(menu.destroy)
		menu.popupEx()
	}
}
