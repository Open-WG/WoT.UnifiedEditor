import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

Rectangle {
	width: parent.width
	height: 25
	z: 0.9
	color: "transparent"

	Misc.Text {
		text: section

		font.bold: true

		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.leftMargin: 10
		anchors.right: parent.right
	}
}
