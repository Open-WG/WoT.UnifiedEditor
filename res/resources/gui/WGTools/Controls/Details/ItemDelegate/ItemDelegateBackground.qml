import QtQuick 2.11
import WGTools.Controls.Details 2.0
import WGTools.Controls.impl 1.0

Rectangle {
	implicitWidth: ControlsSettings.longWidth
	implicitHeight: ControlsSettings.bigHeight

	color: Color.transparent(_palette.color1, 0.15)
	visible: control.down || control.highlighted || control.visualFocus
}
