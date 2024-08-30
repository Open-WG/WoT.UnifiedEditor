import QtQuick 2.11
import WGTools.Controls.Details 2.0

ButtonBackground {
	implicitWidth: ControlsSettings.iconSize
	implicitHeight: ControlsSettings.iconSize
	radius: width / 2
	x: text
		? control.mirrored
			? control.width - width - control.rightPadding
			: control.leftPadding
		: control.leftPadding + (control.availableWidth - width) / 2
	y: control.topPadding + (control.availableHeight - height) / 2

	Rectangle {
		width: parent.width / 2
		height: parent.height / 2
		radius: width / 2
		x: (parent.width - width) / 2
		y: (parent.height - height) / 2
		color: control.icon.color
		visible: control.checked
	}
}
