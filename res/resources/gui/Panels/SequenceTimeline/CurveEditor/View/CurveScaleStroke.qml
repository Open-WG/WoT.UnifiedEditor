import QtQuick 2.11
import WGTools.Misc 1.0 as Misc

Item {
	property alias text: label.text

	width: parent.width
	
	Rectangle {
		width: parent.width
		height: 1
		color: "black"
		opacity: 0.3
	}

	Misc.Text {
		id: label
		text: model.value.toFixed(3)
		color: "grey"
		x: 3

		anchors.bottom: parent.top
		font.pixelSize: 10
	}
}


