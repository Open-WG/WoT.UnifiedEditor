import QtQuick 2.7
import QtQuick.Controls 2.0

Menu {
	readonly property var maxWidth: 150
	readonly property bool hasCheckable: {
		for (var i = 0; i < count; ++i) {
			if (itemAt(i).checkable) {
				return true
			}
		}

		return false
	}

	implicitWidth: {
		var newWidth = 0
		for (var i = 0; i < count; ++i) {
			var currWidth = itemAt(i).implicitWidth
			if (newWidth < currWidth)
				newWidth = currWidth
		}

		newWidth += leftPadding + rightPadding

		return newWidth > maxWidth ? maxWidth : newWidth
	}

	modal: true
	focus: true

	topPadding: 5
	bottomPadding: 5
	leftPadding: 1
	rightPadding: 1

	background: Rectangle {
		id: popupBackground
		color: "#4a4a4a"
		radius: 3

		border.color: "black"
		border.width: 1
	}
}
