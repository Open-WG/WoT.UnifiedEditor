import QtQuick 2.7

import WGTools.AnimSequences 1.0

import "Constants.js" as Constants

Rectangle {
	id: root

	property alias controller: curveEditorController
	property var timelineController: null
	property var context: null

	anchors.fill: parent

	color: Constants.curveEditorBackgroundColor
	//opacity: 0.5

	function getLastFramePos() {
		return timelineController.fromValueToPixels(
			timelineController.fromSecondsToFrames(
			context.sequenceDuration))
	}

	function getFirstFramePos() {
		return timelineController.fromValueToPixels(0)
	}

	CurveEditorController {
		id: curveEditorController
		controlSize: root.height
	}

	MouseArea {
		property var moving: false
		property real prevClickY: 0
		property real prevClickX: 0

		acceptedButtons: Qt.MiddleButton
		propagateComposedEvents: true
		preventStealing: true

		anchors.fill: parent

		onClicked: {
			mouse.accepted = false
		}

		onPressed: {
			if (mouse.button == Qt.MiddleButton) {
				moving = true
				prevClickY = mouse.y
				prevClickX = mouse.x
			}
		}

		onReleased: {
			if (!moving || mouse.button == Qt.MiddleButton) {
				moving = false
				prevClickY = 0
				prevClickX = 0
			}
		}

		onPositionChanged: {
			if (moving) {
				curveEditorController.move(prevClickY - mouse.y)
				prevClickY = mouse.y

				styleData.context.timelineController.move(mouse.x - prevClickX)
				prevClickX = mouse.x
			}
		}

		onWheel: {
			if (wheel.modifiers == Qt.ShiftModifier)
				curveEditorController.zoom(wheel.angleDelta.y, root.height - wheel.y)
			else if (wheel.modifiers == Qt.ControlModifier)
				timelineController.zoom(wheel.angleDelta.y, wheel.x)
			else {
				wheel.accepted = false
			}
		}
	}

	Repeater {
		id: repeater

		model: curveEditorController.scaleModel

		readonly property var origin: root.height
		property var zeroFramePos: root.getFirstFramePos()
		property var lastFramePos: root.getLastFramePos()
		property var delegateWidth: lastFramePos - zeroFramePos

		delegate: Item {
			id: itemDel

			Text {
				text: model.value.toFixed(3)
				color: "grey"

				font.pixelSize: 10

				anchors.bottom: stroke.top
				anchors.left: itemDel.left
				anchors.leftMargin: 3
			}

			Rectangle {
				id: stroke

				height: 1
				width: repeater.delegateWidth

				x: Math.round(repeater.zeroFramePos)
				y: root.height - Math.round(model.position)

				color: "black"
				opacity: 0.3
			}
		}
	}

	Connections {
		target: styleData.context.timelineController
		onScaleChanged: {
			repeater.zeroFramePos = Qt.binding(getFirstFramePos)
			repeater.lastFramePos = Qt.binding(getLastFramePos)
		}
	}
}