import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

ToolTip {
	id: tooltip
	text: control.verifier.error
	x: 0
	y: control.height
	delay: ControlsSettings.tooltipDelay
	timeout: ControlsSettings.tooltipTimeout / 2

	Binding on visible {
		value: false
		when: tooltip.text == "" || !control.hovered
	}

	Binding on visible {
		value: true
		when: tooltip.text.length && control.hovered
	}
}
