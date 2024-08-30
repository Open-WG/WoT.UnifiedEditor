import QtQuick 2.11
import WGTools.GameplaySettings 1.0
import "Details" as Details

Item {
	property alias viewport: borderlineViewData.viewport
	property alias gameplaySettings: borderlineViewData.gameplaySettings

	clip: true

	BorderlineViewData {
		id: borderlineViewData

		changesController: context.changesController
	}
			
	Rectangle {
		id: borderline

		color: "transparent"
		border.color: "red"
		border.width: 1

		x: borderlineViewData.x
		y: borderlineViewData.y
		height: borderlineViewData.height
		width: borderlineViewData.width
		
		MouseArea {
			id: mouseArea

			property var _dragging: false
			property real _prevX
			property real _prevY
			property real _lastValX
			property real _lastValY
			property real _offsetToCenterX
			property real _offsetToCenterY

			anchors.fill: parent

			hoverEnabled: true
			cursorShape: Qt.SizeAllCursor

			onPressed: {
				_dragging = true
				
				var globalPoint = mapToGlobal(mouse.x, mouse.y)

				_prevX = globalPoint.x
				_prevY = globalPoint.y
				_offsetToCenterX = mouse.x
				_offsetToCenterY = mouse.y
				_lastValX = borderline.x
				_lastValY = borderline.y
			}

			onPositionChanged: {
				if (!_dragging)
					return

				var globalPoint = mapToGlobal(mouse.x, mouse.y)

				_lastValX = mouse.x + borderline.x - _offsetToCenterX
				_lastValY = mouse.y + borderline.y - _offsetToCenterY

				borderlineViewData.changeAllBounds(_lastValX,
					_lastValY, false)

				_prevX = globalPoint.x
				_prevY = globalPoint.y
			}

			onReleased: {
				if (_dragging) {
					borderlineViewData.changeAllBounds(_lastValX,
						_lastValY, true)
					_dragging = false
				}
			}
		}
	}

	Details.Draggable {
		position: borderlineViewData.topLeftDragPos

		cursorShape: Qt.SizeFDiagCursor

		Component.onCompleted: dragged.connect(borderlineViewData.changeTopLeftBound)
	}

	Details.Draggable {
		position: borderlineViewData.topMidDragPos

		cursorShape: Qt.SizeVerCursor

		Component.onCompleted: dragged.connect(borderlineViewData.changeTopBound)
	}

	Details.Draggable {
		position: borderlineViewData.topRightDragPos

		cursorShape: Qt.SizeBDiagCursor

		Component.onCompleted: dragged.connect(borderlineViewData.changeTopRightBound)
	}

	Details.Draggable {
		position: borderlineViewData.rightDragPos

		cursorShape: Qt.SizeHorCursor

		Component.onCompleted: dragged.connect(borderlineViewData.changeRightBound)
	}

	Details.Draggable {
		position: borderlineViewData.bottomRightDragPos

		cursorShape: Qt.SizeFDiagCursor

		Component.onCompleted: dragged.connect(borderlineViewData.changeBottomRightBound)
	}

	Details.Draggable {
		position: borderlineViewData.bottomMidDragPos

		cursorShape: Qt.SizeVerCursor

		Component.onCompleted: dragged.connect(borderlineViewData.changeBottomBound)
	}

	Details.Draggable {
		position: borderlineViewData.bottomLeftDragPos

		cursorShape: Qt.SizeBDiagCursor

		Component.onCompleted: dragged.connect(borderlineViewData.changeBottomLeftBound)
	}

	Details.Draggable {
		position: borderlineViewData.leftDragPos

		cursorShape: Qt.SizeHorCursor

		Component.onCompleted: dragged.connect(borderlineViewData.changeLeftBound)
	}

	Rectangle {
		opacity: 0.3
		color: "white"

		anchors {
			top: parent.top
			left: borderline.left
			right: borderline.right
			bottom: borderline.top
		}
	}

	Rectangle {
		opacity: 0.3
		color: "white"

		anchors {
			top: parent.top
			left: borderline.right
			right: parent.right
			bottom: parent.bottom
		}
	}

	Rectangle {
		opacity: 0.3
		color: "white"

		anchors {
			top: borderline.bottom
			left: borderline.left
			right: borderline.right
			bottom: parent.bottom
		}
	}

	Rectangle {
		opacity: 0.3
		color: "white"

		anchors {
			top: parent.top
			left: parent.left
			right: borderline.left
			bottom: parent.bottom
		}
	}
}
