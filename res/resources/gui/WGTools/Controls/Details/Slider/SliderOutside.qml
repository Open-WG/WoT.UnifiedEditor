import QtQuick 2.11

Rectangle {
	property var inverted: control.value < control.minSoft
	transformOrigin: Item.TopLeft
	rotation: (control.horizontal ? -90 : 0) + (inverted ? 0 : 180)
	x: parent.width * (control.horizontal ? control.visualPosition : 0)
	y: control.horizontal && inverted ? parent.height : 0
	z: 100
	width: control.horizontal ? parent.height : parent.width
	height: (control.horizontal ? parent.width : parent.height) * Math.max(control.value - control.maxSoft, control.minSoft - control.value) / (control.to - control.from)
	gradient: Gradient {
		GradientStop {
			color: "#f5a623"
			position: 1 - 10 / height
		}

		GradientStop {
			color: _palette.color12
			position: 1
		}
	}
	
	visible: height > 0
}