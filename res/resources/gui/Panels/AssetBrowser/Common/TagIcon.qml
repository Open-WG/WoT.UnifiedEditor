import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

Rectangle {
	id: root

	property string text: ""

	implicitHeight: 18
	implicitWidth: height

	Misc.Text {
		text: root.text.length ? root.text.charAt(0) : ""
		enabled: false
		color: "#FFFFFF"
		size: "Small"
		font.capitalization: Font.AllUppercase
		anchors.centerIn: parent
	}
}
