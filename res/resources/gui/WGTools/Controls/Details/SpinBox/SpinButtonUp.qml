import QtQuick 2.11
import WGTools.Controls.Details 2.0

ComboBoxIndicator {
	id: indicator
	down: true
	y: Math.round((control.height - height) / 2 - control.topPadding * 2)
	opacity: control.buttonsVisible
	visible: opacity
	pressed: control.up.pressed
	hovered: control.up.hovered
	src: "spinbox-indicator"

	Accessible.name: "+1"

	Binding {
		target: control.up
		property: "indicator"
		value: indicator.visible ? indicator : null
	}

	NumberBehavior on opacity {}
}
