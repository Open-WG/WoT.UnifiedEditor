import QtQuick 2.11
import WGTools.Controls.Details 2.0

BasicSliderContent {
	id: item

	Accessible.name: "Slider"

	property alias sliderRange: sliderRange

	__leftPadding: control.first.handle ? control.first.handle.width / 2 : 0
	__rightPadding: control.second.handle ? control.second.handle.width / 2 : 0
	__topPadding: control.first.handle ? control.first.handle.height / 2 : 0
	__bottomPadding: control.second.handle ? control.second.handle.height / 2 : 0

	Binding {
		target: item.groove; property: "visible"
		value: control.first.handle && control.second.handle && control.first.handle.visible && control.second.handle.visible
	}

	Binding {
		target: item.leftLabel; property: "opacity"
		value: (control.hovered || control.first.pressed || control.second.pressed)
			&& (item.leftLabel.x + item.leftLabel.width) < (control.first.handle.x - control.leftPadding)
	}

	Binding {
		target: item.rightLabel; property: "opacity"
		value: (control.hovered || control.first.pressed || control.second.pressed)
			&& item.rightLabel.x > (control.second.handle.x + control.second.handle.width - control.leftPadding)
	}

	SliderRange {
		id: sliderRange

		readonly property real __rangeSize: Math.abs(control.second.visualPosition - control.first.visualPosition)
		readonly property real __rangePosition: Math.min(control.first.visualPosition, control.second.visualPosition)

		parent: item.groove
		width: parent.width * (control.horizontal ? __rangeSize : 1)
		height: parent.height * (control.horizontal ? 1 : __rangeSize)
		x: control.horizontal ? parent.width * __rangePosition : 0
		y: control.horizontal ? 0 : parent.height * __rangePosition
	}
}

