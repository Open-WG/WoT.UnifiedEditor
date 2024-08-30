import QtQuick 2.11
import QtQuick.Controls 1.4

MouseArea {
	anchors.fill: parent
	acceptedButtons: Qt.LeftButton
	onPressed: {
		if (parent.selectionMode != SelectionMode.SingleSelection) {
			mouse.accepted = false
			return
		}

		if (!(mouse.modifiers & Qt.ControlModifier)) {
			mouse.accepted = false
			return
		}

		if (parent.selection == null) {
			mouse.accepted = false
			return
		}

		var index = parent.indexAt(mouse.x, mouse.y)
		if (!index.valid) {
			mouse.accepted = false
			return
		}

		if (!parent.selection.isSelected(index)) {
			mouse.accepted = false
			return
		}

		parent.selection.clear()
		mouse.accepted = true
	}
}
