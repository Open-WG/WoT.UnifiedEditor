import QtQuick 2.10

MouseArea {
	property var menuComponent
	readonly property var __tableView: parent && parent.hasOwnProperty("currentRow") ? parent : null;

	width: parent.width
	height: parent.height - y
	y: (__tableView && __tableView.headerVisible) ? (__tableView.__listView.headerItem.height) : 0

	acceptedButtons: Qt.RightButton
	enabled: __tableView && menuComponent

	Accessible.ignored: true

	onPressed: {
		let clickedPos = mapToItem(__tableView, mouse.x, mouse.y)
		let row = __tableView.rowAt(clickedPos.x, clickedPos.y)

		if (row != -1) {
			__tableView.forceActiveFocus()
			__tableView.currentRow = row

			if (!__tableView.selection.contains(row)) {
				__tableView.selection.clear()
				__tableView.selection.select(row, row)
			}
		}
	}

	onReleased: {
		let m = menuComponent.createObject(parent)
		m.popupEx()
	}
}
