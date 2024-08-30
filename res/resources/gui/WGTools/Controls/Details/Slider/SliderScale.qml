import QtQuick 2.11
import WGTools.Controls.Details 2.0

Item {
	id: item

	readonly property real unitRange: control.to - control.from
	readonly property real pixelPerUnit: (unitRange > 0) ? width/unitRange : 0
	readonly property real pixelStepSize: control.stepSize * pixelPerUnit

	opacity: control.horizontal
		&& pixelStepSize >= ControlsSettings.spacing
		&& (control.hovered || control.pressed)

	visible: control.ticks.visible

	Repeater {
		model: item.visible && item.opacity
			? Math.ceil(item.width / item.pixelStepSize) + 1
			: null

		Rectangle {
			width: height; height: parent.height
			color: _palette.color10
			x: Math.round(index * item.pixelStepSize - width/2)
			visible: x <= item.width
		}
	}

	NumberBehavior on opacity {}
}
