import QtQuick 2.11
import WGTools.Controls.Details 2.0 as Details

Rectangle {
	readonly property bool readOnly: !control.enabled || control.hasOwnProperty("readOnly") && control.readOnly

	implicitWidth: ControlsSettings.longWidth
	implicitHeight: ControlsSettings.height
	radius: ControlsSettings.radius
	color: readOnly ? "transparent" : _palette.color9

	border.width: ControlsSettings.strokeWidth
	border.color: control.activeFocus
		? _palette.color1
		: readOnly
			? _palette.color7
			: color

	Details.ColorBehavior on color {}
	Details.ColorBehavior on border.color {}
}
