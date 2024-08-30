import QtQuick 2.11
import WGTools.Controls.Details 2.0

BasicSliderHandle {
	src: "image://gui/controls-slider-handle"

	x: control.horizontal
		? control.leftPadding + (control.availableWidth - width) * control.visualPosition
		: control.leftPadding + (control.availableWidth - width) / 2

	y: control.vertical
		? control.visualPosition * (control.height - height)
		: control.topPadding + control.availableHeight / 2
}
