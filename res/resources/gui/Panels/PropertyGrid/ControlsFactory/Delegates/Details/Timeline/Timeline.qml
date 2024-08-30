import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

import "../../Settings.js" as Settings

Rectangle {
	id: timeline

	property var scale: null

	antialiasing: true

	implicitHeight: Settings.timelineHeight

	radius: Settings.timelineBackgroundRadius
	color: enabled
		? Settings.timelineBackgroundColor
		: Settings.timelineBackgroundDisabledColor

	border.width: enabled ? 0 : 1
	border.color: Settings.timelineStrokeDisabledColor

	MouseArea {
		property var _dragging: false
		property real _prevX: 0

		acceptedButtons: Qt.AllButtons

		anchors.fill: parent

		onPressed: {
			if (mouse.button == Qt.MiddleButton) {
				_prevX = mouse.x
				_dragging = true
				cursorShape = Qt.ClosedHandCursor
			}

			parent.forceActiveFocus(Qt.MouseFocusReason)
		}

		onReleased: {
			if (mouse.button == Qt.MiddleButton) {
				_prevX = 0
				_dragging = false
				cursorShape = Qt.ArrowCursor
			}
		}

		onPositionChanged: {
			if (mouse.buttons == Qt.MiddleButton && _dragging) {
				var deltaX = mouse.x - _prevX
				_prevX = mouse.x

				timeline.scale.move(deltaX)
			}
		}

		onWheel: {
			timeline.scale.zoom(wheel.angleDelta.y / 2, wheel.x)
		}
	}

	Item {
		id: timelineHolder

		anchors.fill: parent
		clip: true

		Repeater {
			id: repeater

			Binding on model { value: scale.scaleModel}

			delegate: Rectangle {
				height: timeline.height * Settings.timelineStrokeHeightMultiplier
				width: 1

				x: Math.round(model.position)

				anchors.bottom : parent.bottom
				anchors.alignWhenCentered: false

				color: enabled
					? Settings.timelineStrokeDefaultColor
					: Settings.timelineStrokeDisabledColor

				Misc.Text {
					readonly property var displayText: "%1s:%2f"
					y: -contentHeight / 3
					x: 3

					visible: model.majorityCoeff == 1 ? true : false

					text: displayText.arg(Math.floor(model.value / delegateRoot.sampleRate))
						.arg(model.value % delegateRoot.sampleRate)
					font.pixelSize: 10
					color: enabled
						? Settings.timelineTextDefaultColor
						: Settings.timelineTextDisabledColor
				}
			}
		}

		Rectangle {
			id: endMarker

			height: timeline.height * Settings.timelineStrokeHeightMultiplier
			width: 1

			color: "tomato"

			x: timeline.scale.fromValueToPixels(delegateRoot.maxEnd)

			anchors.bottom : parent.bottom
			anchors.alignWhenCentered: false

			Connections {
				target: timeline.scale
				onScaleChanged: endMarker.x
					= timeline.scale.fromValueToPixels(delegateRoot.maxEnd)
			}
		}

		Rectangle {
			id: cursor

			property var _initialStart: delegateRoot.start

			height: timeline.height
			width: 3

			color: Settings.timelineSliderFocusedBackgroundColor

			anchors.alignWhenCentered: false

			Connections {
				target: delegateRoot
				onCursorTimeChanged: cursor.updatePos()
				onStartChanged: {
					if (finalValue){
						cursor._initialStart = delegateRoot.start
						cursor.updatePos()
					}
				}
			}

			Connections {
				target: timeline.scale
				onScaleChanged: cursor.updatePos()
			}

			function updatePos() {
				cursor.x = timeline.scale.fromValueToPixels(
					delegateRoot.cursorTime + cursor._initialStart)
					- cursor.width / 2
			}
		}
	}
	Rectangle {
		id: startGreyZone

		anchors.left: parent.left
		anchors.right: startSlider.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom

		anchors.margins: timeline.border.width

		color: Settings.timelineGreyAreaColor
		opacity: Settings.timelineGreyAreaOpacity

		radius: parent.radius
	}

	Rectangle {
		id: endGreyZone

		anchors.left: endSlider.right
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.bottom: parent.bottom

		anchors.margins: timeline.border.width

		color: Settings.timelineGreyAreaColor
		opacity: Settings.timelineGreyAreaOpacity

		radius: parent.radius
	}

	TimelineSlider {
		id: startSlider
		anchors.verticalCenter: timeline.verticalCenter

		scale: timeline.scale
		Binding on value {
			value: delegateRoot.start
		}

		visible: x + width / 2 >= 0 && x + width / 2 <= timeline.width

		z: x <= minDrag + width
			? 0
			: 1

		minDrag: timeline.scale.fromValueToPixels(0)
		maxDrag: endSlider.x

		onValueModified: {
			delegateRoot.setStart(newValue, !commit)
		}

		Connections {
			target: timeline.scale
			onScaleChanged: startSlider.minDrag 
				= timeline.scale.fromValueToPixels(0)
		}
	}

	TimelineSlider {
		id: endSlider
		anchors.verticalCenter: timeline.verticalCenter

		scale: timeline.scale
		Binding on value {
			value: delegateRoot.end
		}

		visible: x + width / 2 >= 0 && x + width / 2 <= timeline.width

		minDrag: startSlider.x
		maxDrag: timeline.scale.fromValueToPixels(delegateRoot.maxEnd)

		Connections {
			target: timeline.scale
			onScaleChanged: endSlider.maxDrag 
				= timeline.scale.fromValueToPixels(delegateRoot.maxEnd)
		}

		onValueModified: {
			delegateRoot.setEnd(newValue, !commit)
		}
	}

	Binding {
		target: scale
		property: "controlSize"
		value: Math.max(timelineHolder.width, 0)
	}
}
