import QtQuick 2.10
import WGTools.Misc 1.0 as Misc

Rectangle {
	id: root

	property alias text: title.text

	implicitWidth: title.implicitWidth
	implicitHeight: title.implicitHeight

	Misc.Text {
		id: title
		color: _palette.color1
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		size: "Tiny"
		anchors.fill: parent
	}
}
