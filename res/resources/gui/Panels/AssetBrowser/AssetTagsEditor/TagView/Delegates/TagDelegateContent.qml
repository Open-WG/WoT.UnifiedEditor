import QtQuick 2.10
import WGTools.Misc 1.0 as Misc

Flickable {
	implicitWidth: contentWidth
	implicitHeight: contentHeight
	contentWidth: title.width
	contentHeight: title.height
	boundsBehavior: Flickable.StopAtBounds
	interactive: contentWidth > width
	clip: true

	Misc.Text {
		id: title
		enabled: false
		// textFormat: Text.RichText
		color: _palette.color1
		text: control.text
	}
}
