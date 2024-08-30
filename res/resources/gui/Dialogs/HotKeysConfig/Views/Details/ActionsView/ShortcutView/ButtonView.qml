import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

Label {
	width: Math.max(20, implicitWidth)
	height: 18

	horizontalAlignment: Text.AlignHCenter
	verticalAlignment: Text.AlignVCenter

	padding: ControlsSettings.smallPadding
	leftPadding: ControlsSettings.padding
	rightPadding: ControlsSettings.padding
	color: _palette.color10

	background: Rectangle {
		radius: ControlsSettings.radius
		color: "#f2f2f2"
	}
}
