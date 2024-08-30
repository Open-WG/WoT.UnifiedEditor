import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

Label {
	id: control
	width: Math.max(implicitWidth, ControlsSettings.longWidth)
	padding: ControlsSettings.smallPadding
	rightPadding: ControlsSettings.padding
	leftPadding: ControlsSettings.padding

	verticalAlignment: Text.AlignVCenter
	horizontalAlignment: Text.AlignHCenter

	background: TextFieldBackground {}
}
