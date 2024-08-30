import QtQuick 2.11
import WGTools.Controls.Details 2.0

BasicSliderHandle {
	id: handle
	rightPadding: contentItem.implicitWidth
	focusPolicy: Qt.StrongFocus
	src: "image://gui/controls-slider-handle-right"

	x: control.leftPadding + (control.horizontal
		? (control.availableWidth - width) * control.second.visualPosition + (width / 2)
		: control.availableWidth / 2)

	y: control.topPadding + (control.vertical
		? (control.availableHeight - height) * control.second.visualPosition + (height / 2)
		: control.availableHeight / 2)

	Connections {
		target: control.second
		onMoved: handle.forceActiveFocus()
	}
}
