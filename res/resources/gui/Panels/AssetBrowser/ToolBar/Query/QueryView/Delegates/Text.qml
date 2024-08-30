import QtQuick 2.7
import WGTools.Misc 1.0 as Misc
import "../../../../Common" as Common

Common.ClosableDelegateWrapper {
	id: wrapper
	height: parent.height
	color: _palette.color5

	Misc.Text {
		enabled: false
		leftPadding: 5
		rightPadding: wrapper.closable ? 0 : leftPadding
		text: model.display
		size: "Small"

		font.bold: true

		anchors.verticalCenter: parent.verticalCenter
		anchors.verticalCenterOffset: 1
	}
}
