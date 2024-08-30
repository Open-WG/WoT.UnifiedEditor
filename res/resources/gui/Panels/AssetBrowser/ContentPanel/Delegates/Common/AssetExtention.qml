import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

Rectangle {
	id: root

	property alias extension: extensionText.text
	property alias capitalization: extensionText.font.capitalization

	implicitWidth: extensionText.implicitWidth
	implicitHeight: extensionText.implicitHeight
	color: _palette.color8

	Misc.Text {
		id: extensionText
		leftPadding: 10
		rightPadding: leftPadding
		verticalAlignment: Text.AlignVCenter
		elide: Text.ElideRight
		size: "Small"
		anchors.fill: parent
	}
}
