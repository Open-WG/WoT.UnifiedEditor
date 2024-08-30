import QtQuick 2.11

MouseArea {
	id: area

	property alias frameData: selectionFrameData
	property bool moving: false

	property real _movingX: 0
	property real _movingY: 0

	property real prevClickX: 0
	property real prevClickY: 0

	signal moved(real deltaX, real deltaY)
	signal movingFinished()
	signal zoomed(real delta, bool toCursor)
	signal updateSelection(bool clearAndSelect)
	
	acceptedButtons: Qt.LeftButton | Qt.MidButton
	propagateComposedEvents: true
	hoverEnabled: true
	preventStealing: true

	onPressed: {
		moving = true

		frameData.active = (mouse.button == Qt.LeftButton)
		if (frameData.active) {
			frameData.x1 = frameData.x2 = mouse.x
			frameData.y1 = frameData.y2 = mouse.y
		}

		if (mouse.button == Qt.MidButton) {
			_movingX = mouse.x
			_movingY = mouse.y
			cursorShape = Qt.OpenHandCursor
		}

		mouse.accepted = true
	}

	onReleased: {
		if (mouse.button == Qt.MidButton) {
			_movingX = _movingY = 0
			cursorShape = Qt.ArrowCursor

			movingFinished()
		}

		if (frameData.active) {
			var clearAndSelect = !(mouse.modifiers & Qt.ControlModifier)
			updateSelection(clearAndSelect)

			frameData.active = false
		}

		moving = false
	}

	onPositionChanged: {
		if (!moving)
			return

		if (mouse.buttons & Qt.LeftButton) {
			frameData.x2 = Math.min(Math.max(mouse.x, 0), width)
			frameData.y2 = Math.min(Math.max(mouse.y, 0), height)
		}

		if (mouse.buttons & Qt.MidButton) {
			moved(mouse.x - _movingX, mouse.y - _movingY)

			_movingX = mouse.x
			_movingY = mouse.y
			cursorShape = Qt.ClosedHandCursor
		}
	}

	onClicked: {
		forceActiveFocus()
	}

	onWheel: {
		if (wheel.modifiers == Qt.ControlModifier)
			zoomed(wheel.angleDelta.y, false)
		else if (wheel.modifiers == Qt.AltModifier)
			zoomed(wheel.angleDelta.x, true)
		else 
			wheel.accepted = false
	}

	SelectionFrameData {
		id: selectionFrameData
	}
}
