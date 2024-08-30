import QtQuick 2.11

MouseArea {
	id: area
	
	readonly property alias moving: area._moving

	property var _moving: false
	property real _initialY: 0
	property real _prevClickY: 0

	signal moved(real delta)
	signal movingFinished()
	signal zoomed(real delta, bool toCursor)

	acceptedButtons: Qt.LeftButton | Qt.MiddleButton
	propagateComposedEvents: true
	hoverEnabled: true
	preventStealing: true

	onPressed: {
		_moving = true
		_initialY = _prevClickY = mouse.y

		cursorShape = Qt.ClosedHandCursor
	}

	onReleased: {
		cursorShape = Qt.ArrowCursor

		_prevClickY = 0
		_moving = false

		movingFinished()
	}

	onPositionChanged: {
		if (_moving) {
			var deltaY = mouse.y - _prevClickY
			_prevClickY = mouse.y

			moved(deltaY)
		}
	}

	onWheel: {
		if (wheel.modifiers == Qt.ControlModifier)
			zoomed(wheel.angleDelta.y, false)
		else if (wheel.modifiers == Qt.AltModifier)
			zoomed(wheel.angleDelta.y, true)
		else 
			wheel.accepted = false
	}
}
