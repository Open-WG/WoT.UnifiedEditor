import QtQuick 2.11

Rectangle {
	color: _palette.color2

	Column {
		width: Math.min(implicitWidth, parent.width)
		height: Math.min(implicitHeight, parent.height)
		clip: true
		anchors.centerIn: parent

		Image {
			width: Math.min(implicitWidth, parent.width)
			height: Math.min(implicitHeight, parent.height)
			source: "image://gui/no-image"
			anchors.horizontalCenter: parent.horizontalCenter
		}

		Text {
			text: "No image"
			color: _palette.color3
			anchors.horizontalCenter: parent.horizontalCenter
		}
	}
}
