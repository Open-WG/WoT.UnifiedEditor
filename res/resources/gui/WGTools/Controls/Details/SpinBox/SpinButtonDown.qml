import QtQuick 2.11
import WGTools.Controls.Details 2.0

ComboBoxIndicator {
	id: indicator
	down: false
	y: Math.round((control.height + height) / 2)
	opacity: control.buttonsVisible
	visible: opacity
	pressed: control.down.pressed
	hovered: control.down.hovered
	src: "spinbox-indicator"

	Accessible.name: "-1"

	Binding {
		target: control.down
		property: "indicator"
		value: indicator.visible ? indicator : null
	}

	NumberBehavior on opacity {}
}
