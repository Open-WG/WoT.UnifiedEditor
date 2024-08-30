import QtQuick 2.11

MouseArea {
	id: navigator

	property bool _moving: false
	property real _prevClickY: 0
	property real _prevClickX: 0

	signal moved(real deltaX, real deltaY)
	signal zoomedVertically(real delta, real position)
	signal zoomedHorizontally(real delta, real position)

	acceptedButtons: Qt.LeftButton | Qt.MiddleButton
	propagateComposedEvents: true
	preventStealing: true

	onClicked: {
		mouse.accepted = false
	}

	onPressed: {
		if (mouse.button == Qt.MidButton) {
			_moving = true
			_prevClickY = mouse.y
			_prevClickX = mouse.x
			cursorShape = Qt.OpenHandCursor
			return
		}

		if (mouse.button == Qt.LeftButton) {
			mouse.accepted = false
		}
	}

	onReleased: {
		if (mouse.button == Qt.MidButton) {
			_moving = false
			_prevClickY = 0
			_prevClickX = 0
			cursorShape = Qt.ArrowCursor
		}
	}

	onPositionChanged: {
		if (_moving && mouse.buttons & Qt.MidButton) {
			navigator.moved(mouse.x - _prevClickX, mouse.y - _prevClickY)
			_prevClickX = mouse.x
			_prevClickY = mouse.y
			cursorShape = Qt.ClosedHandCursor
		}
	}

	onWheel: {
		if (wheel.modifiers == Qt.ShiftModifier)
			navigator.zoomedVertically(wheel.angleDelta.y, height - wheel.y)
		else if (wheel.modifiers == Qt.ControlModifier)
			navigator.zoomedHorizontally(wheel.angleDelta.y, wheel.x)
		else {
			wheel.accepted = false
		}
	}
}
