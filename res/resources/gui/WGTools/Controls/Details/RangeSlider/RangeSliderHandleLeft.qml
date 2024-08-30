import QtQuick 2.11
import WGTools.Controls.Details 2.0

BasicSliderHandle {
	id: handle
	leftPadding: contentItem.implicitWidth
	focusPolicy: Qt.StrongFocus
	src: "image://gui/controls-slider-handle-left"

	x: control.leftPadding + (control.horizontal
		? (control.availableWidth - width) * control.first.visualPosition - (width / 2)
		: control.availableWidth / 2)

	y: control.topPadding + (control.vertical
		? (control.availableHeight - height) * control.first.visualPosition - (height / 2)
		: control.availableHeight / 2)

	Connections {
		target: control.first
		onMoved: handle.forceActiveFocus()
	}
}
