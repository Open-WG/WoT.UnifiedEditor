import QtQuick 2.10
import WGTools.Misc 1.0 as Misc
import WGTools.Controls.Details 2.0

Rectangle {
	property alias text: title.text

	implicitWidth: 100
	implicitHeight: 24
	color: "transparent"

	Misc.Text {
		id: title
		color: _palette.color1
		verticalAlignment: Text.AlignVCenter
		padding: ControlsSettings.padding
		font.bold: true
		anchors.fill: parent
	}
}
