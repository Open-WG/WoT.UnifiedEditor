import QtQuick 2.11
import WGTools.Controls.Details 2.0 as Details

Rectangle {
	property bool highlighted: control && control.hasOwnProperty("checked") && control.checked

	readonly property color __color: { // for animation correctness
		if (!control.enabled)
			return highlighted ? _palette.color7 : "transparent"

		let ret = highlighted ? _palette.color12 : _palette.color5

		if (control.down || control.pressed)
			return Qt.tint(ret, _palette.pressedTint)

		if (control.hovered)
			return Qt.tint(ret, _palette.hoveredTint)

		if (control.flat && !highlighted)
			return "transparent"

		return ret
	}

	implicitWidth: implicitHeight
	implicitHeight: ControlsSettings.height
	radius: ControlsSettings.radius
	color: __color

	border.width: ControlsSettings.strokeWidth
	border.color: {
		if (control.visualFocus)
			return _palette.color1

		if (!control.enabled && !highlighted && !control.flat)
			return _palette.color7

		return __color
	}

	Details.ColorBehavior on color {}
	Details.ColorBehavior on border.color {}
}
