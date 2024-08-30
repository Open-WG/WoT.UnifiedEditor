import QtQuick 2.11
import WGTools.Controls.Details 2.0

BasicSliderContent {
	id: item

	__leftPadding: control.handle ? control.handle.width / 2 : 0
	__topPadding: control.handle ? control.handle.height / 2 : 0

	Binding {
		target: item.groove; property: "visible"
		value: control.handle
	}

	Binding {
		target: item.leftLabel; property: "opacity"
		value: (control.hovered || control.pressed)
			&& (item.leftLabel.x + item.leftLabel.width < control.handle.x - control.leftPadding || !control.handle.visible)
	}

	Binding {
		target: item.rightLabel; property: "opacity"
		value: (control.hovered || control.pressed)
			&& (item.rightLabel.x > control.handle.x + control.handle.width - control.leftPadding || !control.handle.visible)
	}

	SliderRange {
		parent: item.groove
		readonly property var min: (control.minSoft - control.from) / (control.to - control.from)
		readonly property var size: Math.abs(control.visualPosition - min)
		x: parent.width * (control.horizontal ? min : 0)
		y: parent.height * (control.horizontal ? 0 : min)
		width: parent.width * (control.horizontal ? size : 1)
		height: parent.height * (control.horizontal ? 1 : size)
		visible: !outside.inverted
	}

	SliderOutside {
		id: outside
		parent: item.groove
	}
}
