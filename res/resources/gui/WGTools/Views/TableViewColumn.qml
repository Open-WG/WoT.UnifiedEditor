import QtQuick 2.11
import QtQuick.Controls 1.4

TableViewColumn {
	id: column
	width: 0

	readonly property Timer __resizeTimer: Timer {
		interval: 10
		onTriggered: width = getMaximumImplicitWidth()
	}

	readonly property Connections __connections1: Connections {
		target: __view ? __view.__model : null
		onRowsRemoved: __resizeTimer.restart()
	}

	readonly property real implicitWidth: getMaximumImplicitWidth()
	onImplicitWidthChanged: width = Math.max(width, implicitWidth)

	on__ViewChanged: {
		for (var i = 0; __index === -1 && i < __view.__columns.length; ++i) {
			if (__view.__columns[i] === this) {
				__index = i
			}
		}
	}

	function getMaximumImplicitWidth() {
		var w = 0

		if (__index >= 0) {
			var listdata = __view.__listView.children[0]

			for (var row = 0; row < listdata.children.length; ++row) {
				var item = listdata.children[row] ? listdata.children[row].rowItem : undefined
				if (item) { // FocusScope { id: rowitem }
					item = item.children[1]
					if (item) { // Row { id: itemrow }
						item = item.children[__index]
						if (item) { // Repeater.delegate a.k.a. __view.__itemDelegateLoader
							var indent = __view.__isTreeView && __index === 0 ? item.__itemIndentation : 0
							item  = item.item
							if (item && item.hasOwnProperty("implicitWidth")) {
								w = Math.max(w, item.implicitWidth + indent)
							}
						}
					}
				}
			}
		}

		return w
	}
}
