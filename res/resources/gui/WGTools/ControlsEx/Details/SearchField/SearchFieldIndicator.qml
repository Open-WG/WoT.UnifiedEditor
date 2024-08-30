import QtQuick 2.11
import WGTools.Controls.Details 2.0 as Details

Details.ColorImage {
	readonly property real labelTextWidth: width + placeholderMetrics.width + (placeholderMetrics.width ? control.spacing : 0)
	readonly property real labelTextSlotWidth: control.width - control.padding - control.rightPadding
	readonly property real xOffset: (labelTextSlotWidth - labelTextWidth) / 2
	property real xMover: control.activeFocus || control.text ? 0 : 1

	src: "controls-magnifier"
	x: control.padding + xOffset * xMover
	y: control.topPadding + (control.availableHeight - height) / 2

	TextMetrics {
		id: placeholderMetrics
		font: control.placeholder.font
		text: control.placeholder.text
	}

	Details.NumberBehavior on xMover {}
}
