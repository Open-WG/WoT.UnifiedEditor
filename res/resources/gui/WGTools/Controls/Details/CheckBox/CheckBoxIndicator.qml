import QtQuick 2.11
import WGTools.Controls.Details 2.0

ButtonBackground {
	implicitWidth: ControlsSettings.iconSize
	implicitHeight: ControlsSettings.iconSize
	x: text
		? control.mirrored
			? control.width - width - control.rightPadding
			: control.leftPadding
		: control.leftPadding + (control.availableWidth - width) / 2
	y: control.topPadding + (control.availableHeight - height) / 2
	highlighted: control.checkState != Qt.Unchecked

	CheckBoxIndicatorChecked {
		visible: control.checkState === Qt.Checked
	}

	CheckBoxIndicatorTristate {
		visible: control.tristate
	}
}
