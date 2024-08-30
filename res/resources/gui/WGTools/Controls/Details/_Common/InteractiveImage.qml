import QtQuick 2.11
import WGTools.Controls.Details 2.0

ColorImage {
	property bool pressed: control.pressed
	property bool hovered: control.hovered
	property bool highlighted: control.visualFocus

	color: highlighted
		? _palette.color1
		: enabled
			? pressed
				? _palette.color3
				: hovered
					? _palette.color1
					: _palette.color2
			: _palette.color3
}
