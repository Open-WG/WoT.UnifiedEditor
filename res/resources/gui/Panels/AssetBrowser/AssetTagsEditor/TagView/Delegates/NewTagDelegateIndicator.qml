import QtQuick 2.10

Rectangle {
	width: control.icon.width
	height: control.icon.height
	x: control.padding
	y: control.topPadding + (control.availableHeight - height) / 2
	color: "white"

	border.width: 1
	border.color: _palette.color3

	Rectangle {
		width: parent.width * 0.5
		height: parent.border.width
		x: (parent.width - width) / 2
		y: (parent.height - height) / 2
		color: parent.border.color
	}

	Rectangle {
		width: parent.border.width
		height: parent.width * 0.5
		x: (parent.width - width) / 2
		y: (parent.height - height) / 2
		color: parent.border.color
	}
}
