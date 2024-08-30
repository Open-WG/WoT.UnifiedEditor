import QtQuick 2.11
import QtQuick.Controls.impl 2.4 as Impl
import WGTools.Controls.Details 2.0 as Details

Impl.IconLabel {
	id: iconLabel
	spacing: control.spacing
	mirrored: control.mirrored
	display: control.display

	icon: control.icon
	text: control.flat ? "" : control.text
	font: control.font

	color: control.enabled ? _palette.color1 : _palette.color3

	// effects
	Details.ColorBehavior on color {}

	// TODO: temporaty workaround. fix empty buttons label
	Connections {
		target: control

		onAvailableWidthChanged: {
			iconLabel.width = 0
			iconLabel.width = control.availableWidth
		}

		onAvailableHeightChanged: {
			iconLabel.height = 0
			iconLabel.height = control.availableHeight
		}
	}
}
