import QtQuick 2.11
import QtQuick.Controls.impl 2.3 as Impl

Impl.IconLabel {
	spacing: control.spacing
	mirrored: control.mirrored
	display: control.display

	icon: control.icon
	text: control.text
	font: control.font
	color: _palette.color3
}
