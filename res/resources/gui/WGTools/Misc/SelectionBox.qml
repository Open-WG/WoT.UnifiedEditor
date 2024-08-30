import QtQuick 2.11

MouseArea {
	id: selBoxControl

	signal selectionFinished(real x, real y, real width, real height,
		var modifiers)

	acceptedButtons: Qt.LeftButton
	propagateComposedEvents: true
	preventStealing: true

	property var __isDragActive: drag.active
	property var __initX: 0
	property var __initY: 0
	property var __consumeEvents: false
	property var __modifiers

	Rectangle {
		id: box

		x: __initX
		y: __initY

		visible: __isDragActive
		color: Qt.rgba(border.color.r, border.color.g,
			border.color.b, 0.2)

		border.color: _palette.color2
		border.width: 1
	}

	onPositionChanged: {
		__modifiers = mouse.modifiers

		if (!__isDragActive)
			return

		var newWidth = mouse.x - __initX
		var newHeight = mouse.y - __initY

		box.width = newWidth
		box.height = newHeight

		if (newWidth > 0) {
			box.width = newWidth
			box.x = __initX
		}
		else {
			box.width = -newWidth
			box.x = __initX + newWidth
		}

		if (newHeight > 0) {
			box.height = newHeight
			box.y = __initY
		}
		else {
			box.height = -newHeight
			box.y = __initY + newHeight
		}
	}

	onPressedButtonsChanged: {
		if (pressedButtons & Qt.LeftButton) {
			__initX = selBoxControl.mouseX
			__initY = selBoxControl.mouseY
			__isDragActive = true
		}
		else {
			if (box.width > 0 && box.height > 0) {
				__consumeEvents = true
				selectionFinished(box.x, box.y, box.width, box.height,
					__modifiers)
			}

			box.width = 0
			box.height = 0

			__isDragActive = false
		}
	}

	onClicked: {
		mouse.accepted = __consumeEvents
		__consumeEvents = false
	}

	onDoubleClicked: {
		mouse.accepted = __consumeEvents
		__consumeEvents = false
	}

	onPressAndHold: {
		mouse.accepted = __consumeEvents
		__consumeEvents = false
	}
}
