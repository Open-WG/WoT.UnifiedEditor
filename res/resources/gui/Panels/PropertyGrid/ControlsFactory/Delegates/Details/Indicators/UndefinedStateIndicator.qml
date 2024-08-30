import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

Rectangle {
	radius: 5
	implicitWidth: radius * 2
	implicitHeight: radius * 2
	color: "tomato"

	Misc.Text {
		text: "?"
		color: "white"
		horizontalAlignment: TextInput.AlignHCenter
		verticalAlignment: TextInput.AlignVCenter
		fontSizeMode: Text.Fit
		enabled: false

		anchors.fill: parent
	}
}
