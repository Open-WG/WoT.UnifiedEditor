import QtQuick 2.11
import Panels.SequenceTimeline 1.0

Item {
	id: root

	signal inTangentChanged(real val, bool turnToStepped)
	signal outTangentChanged(real val, bool turnToStepped)
	signal needToApplyChanges()

	property alias rightHandleRotation: rightHandleHolder.rotation
	property alias leftHandleRotation: leftHandleHolder.rotation

	property var color: "white"
	property bool independentHandles: false

	property var keyPosition: 0
	property var keyValue: 0

	property var curveViewID: null
	property var timelineViewID: null
	property var curveController: null
	property var curveMappingOffset: null

	readonly property real handleWidth: 1
	readonly property real handleLength: 40
	readonly property real circleRadius: 5

	Item {
		id: rightHandleHolder
		width: 50
		height: 10
		transformOrigin: Item.Left

		anchors.left: parent.right
		anchors.verticalCenter: parent.verticalCenter

		Canvas {
			id: rightHandle
			antialiasing: true

			anchors.fill: parent

			onPaint: {
				var ctx = getContext("2d")

				if (!ctx) {
					console.log(">>>>> TangentControllerItem: context is not available")
					return;
				}

				ctx.fillStyle = color
				ctx.fillRect(0, height / 2 - handleWidth, handleLength, handleWidth)

				ctx.strokeStyle = color
				var ellipseX = handleLength
				var ellipseY = (height / 2) - (circleRadius / 2) - 0.5

				ctx.ellipse(ellipseX, ellipseY, 5, 5)
				ctx.stroke()
				ctx.fill()
			}
		}

		MouseArea {
			id: rightHandleMA

			Accessible.name: "Right Handle"

			property var dragging: false
			property var applyChanges: false

			width: circleRadius * 2 + 1
			height: width
			x: handleLength - circleRadius / 2
			preventStealing: true

			anchors.verticalCenter: parent.verticalCenter

			onPressed: {
				dragging = true
			}

			onReleased: {
				dragging = false

				if (applyChanges) {
					needToApplyChanges()
					applyChanges = false
				}
			}

			onPositionChanged: {
				if (!dragging)
					return
					
				var timelineViewPoint = mapToItem(timelineViewID, mouseX, mouseY)
				var curveViewRect = mapToItem(curveViewID, mouseX, mouseY)

				var mouseXMapped 
					= context.timelineController.fromPixelsToValue(timelineViewPoint.x)
				mouseXMapped = context.timelineController.fromFramesToSeconds(mouseXMapped)
				var mouseYMapped = curveMappingOffset - curveViewRect.y
				mouseYMapped = curveController.fromPixelsToValue(mouseYMapped)

				var vector = Qt.vector2d(mouseXMapped - keyPosition, mouseYMapped - keyValue)
				vector = vector.normalized()
				var angle = Math.acos(vector.x) * (180 / Math.PI)

				var retVal = vector.y / vector.x
				var turnToStepped = false

				if (angle <= -90 || angle >= 90)
					turnToStepped = true

				applyChanges = true
				outTangentChanged(retVal, turnToStepped)
			}
		}
	}

	Item {
		id: leftHandleHolder
		width: 50
		height: 10
		transformOrigin: Item.Right

		anchors.right: parent.left
		anchors.verticalCenter: parent.verticalCenter

		Canvas {
			id: leftHandle
			antialiasing: true

			anchors.fill: parent

			onPaint: {
				var ctx = getContext("2d")

				if (!ctx) {
					console.log(">>>>> TangentControllerItem: context is not available")
					return;
				}

				ctx.fillStyle = color
				ctx.fillRect(width - handleLength, height / 2 - handleWidth, handleLength, handleWidth)

				ctx.strokeStyle = color
				var ellipseX = width - handleLength - circleRadius
				var ellipseY = (height / 2) - (circleRadius / 2) - 0.5

				ctx.ellipse(ellipseX, ellipseY, 5, 5)
				ctx.stroke()
				ctx.fill()
			}
		}

		MouseArea {
			id: leftHandleMA

			Accessible.name: "Left handle"

			property var dragging: false
			property var applyChanges: false

			width: circleRadius * 2 + 1
			height: width
			x: leftHandle.width - handleLength - width / 2 - 2
			preventStealing: true

			anchors.verticalCenter: parent.verticalCenter

			onPressed: {
				dragging = true
			}

			onReleased: {
				dragging = false
				if (applyChanges) {
					needToApplyChanges()
					applyChanges = false
				}
			}

			onPositionChanged: {
				if (!dragging)
					return

				var timelineViewPoint = mapToItem(timelineViewID, mouseX, mouseY)
				var curveViewRect = mapToItem(curveViewID, mouseX, mouseY)

				var mouseXMapped 
					= context.timelineController.fromPixelsToValue(timelineViewPoint.x)
				mouseXMapped = context.timelineController.fromFramesToSeconds(mouseXMapped)
				var mouseYMapped = curveMappingOffset - curveViewRect.y
				mouseYMapped = curveController.fromPixelsToValue(mouseYMapped)

				var vector = Qt.vector2d(mouseXMapped - keyPosition, mouseYMapped - keyValue)
				vector = vector.normalized()

				vector = vector.times(-1)

				var angle = Math.acos(vector.x) * (180 / Math.PI)
				var retVal = vector.y / vector.x
				var turnToStepped = false

				if (angle <= -90 || angle >= 90)
					turnToStepped = true

				applyChanges = true
				inTangentChanged(retVal, turnToStepped)
			}
		}
	}
}
