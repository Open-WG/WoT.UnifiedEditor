import QtQuick 2.11
import WGTools.Controls.Details 2.0 as Details

Details.InteractiveImage {
	id: indicator

	property bool down: control.down

	x: control.width - control.padding - width
	y: control.topPadding + (control.availableHeight - height) / 2
	hovered: false
	pressed: false
	highlighted: false
	src: "combobox-indicator"

	transform: Rotation { 
		origin.x: width / 2
		origin.y: height / 2
		angle: indicator.down ? 180 : 0
	}

	Details.IndicatorBB {a:indicator}
}
