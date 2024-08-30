import QtQuick 2.11

Item {
	id: root

	property var position
	property alias cursorShape: mouseArea.cursorShape

	signal dragged(real newX, real newY, bool commit)

	width: 0
	height: 0
	x: position.x
	y: position.y

	anchors.alignWhenCentered: false

	Rectangle {
		height: 7
		width: height
		color: "white"
		radius: height / 2

		border.color: "#f63131"
		border.width: 1

		anchors.centerIn: parent
		anchors.alignWhenCentered: false

		MouseArea {
			id: mouseArea

			property var _dragging: false
			property real _lastValX
			property real _lastValY

			anchors.fill: parent

			hoverEnabled: true

			onPressed: {
				_dragging = true
				_lastValX = root.x + mouse.x
				_lastValY = root.y + mouse.y
			}

			onPositionChanged: {
				if (!_dragging)
					return

				_lastValX = root.x + mouse.x
				_lastValY = root.y + mouse.y
				root.dragged(_lastValX, _lastValY, false)
			}

			onReleased: {
				if (_dragging) {
					root.dragged(_lastValX, _lastValY, true)
					_dragging = false
				}
			}
		}
	}
}
