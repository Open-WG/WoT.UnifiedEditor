import QtQml 2.2
import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.AnimSequences 1.0 as Sequences
import Panels.SequenceTimeline 1.0

Item {
	id: cursor

	property var timelineController: null
	property var playbackController: null
	property var isInputVisible: false

	width: timeTextMetrics.width + Constants.cursorTextPadding
	x: getRectanglePosition()

	anchors.top: parent.top
	anchors.bottom: parent.bottom
	anchors.alignWhenCentered: false

	function getPosition() {
		if (playbackController) {
			return Math.round(timelineController.fromValueToPixels(playbackController.sample * context.frameRate))
		}

		return 0
	}

	function getRectanglePosition() {
		var position = getPosition() - (cursor.width / 2 - 1)
		var xMax = position + cursor.width

		if (xMax > cursor.parent.width) {
			position = cursor.parent.width - cursor.width
		}

		return position < 0 ? 0 : position
	}

	function getImagePosition() {
		return getPosition() - (cursor.x + cursorImage.width / 2) + 1
	}

	function getCurrentSecond() {
		return (Math.round(playbackController ? playbackController.sample * 100 : 0) / 100).toFixed(2)
	}

	function getCurrentFrame() {
		return playbackController ? Math.floor(playbackController.sample * context.frameRate) : 0
	}

	function isVisible() {
		var position = getPosition()
		return position >= 0 && position <= cursor.parent.width - 1
	}

	Image {
		id: cursorImage

		source: Constants.imageCursor + "?color=" + encodeURIComponent(Constants.playbackCursorColor)
		width: Constants.cursorTriangleWidth
		height: Constants.cursorTriangleHeight
		anchors.top: cursorRectangle.bottom
		x: getImagePosition()

		visible: cursorRectangle.visible
		rotation: 180
		smooth: true
	}

	Rectangle {
		id: cursorRectangle
		radius: Constants.cursorRectangleRadius
		color: Constants.playbackCursorColor
		anchors.fill: parent
		anchors.bottomMargin: Constants.cursorRectangleBottomMargin
		visible : isVisible()

		TextMetrics {
			id: timeTextMetrics
			font.family: Constants.segoiUI
			font.pointSize: Constants.cursorFontSize
			text: {
				"%1 sec / %2 frame".arg(getCurrentSecond()).arg(getCurrentFrame())
			}
		}

		Text {
			text: timeTextMetrics.text
			color: Constants.fontColor
			font: timeTextMetrics.font
			anchors.horizontalCenter : parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
		}

		TextField {
			id: input
			visible: false
			anchors.fill: parent

			validator: RegExpValidator {
				regExp: /\d+(f|((\.\d+)?s)?)?/
			}

			onActiveFocusChanged: {
				if (!activeFocus) {
					visible = false;
				}
			}

			function parseTimeValue() {
				var value = text
				var isFrames = value.includes('f') // Check if we got frames
				value.replace(/\D/g, '')
				value = parseFloat(value)
				
				if (isFrames) {
					value = Math.round(value)
					value /= context.frameRate
					value += 0.001  // Add epsilon to get the correct frame
				}

				return value
			}

			Keys.onPressed: {
				if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
					var value = parseTimeValue()

					// Try to set received time value
					var startTime = 0
					var endTime = 0

					if (context.timelineLimitController) {
						startTime = context.timelineLimitController.leftBorder / context.frameRate
						endTime = context.timelineLimitController.rightBorder / context.frameRate
					} else {
						endTime = context.sequenceModel.sequenceDuration
					}
					
					playbackController.sample = Math.min(Math.max(value, startTime), endTime)

					if (!timelineController.isSecondVisible(value))
						timelineController.focusAroundSecond(value)

					focus = false;
					event.accepted = true;
				} else if (event.key == Qt.Key_Escape) {
					focus = false;
				}
			}
		}
	}

	onIsInputVisibleChanged : {
		input.visible = isInputVisible
		if (isInputVisible) {
			input.forceActiveFocus();
			input.text = getCurrentSecond();
		}
	}

	Connections {
		target: timelineController
		ignoreUnknownSignals: true
		onScaleChanged: {
			cursor.x = Qt.binding(getRectanglePosition)
			cursorImage.x = Qt.binding(getImagePosition)
			cursorRectangle.visible = Qt.binding(isVisible)
		}
	}

	Connections {
		target: playbackController
		ignoreUnknownSignals: true

		onSampleChanged: {
			cursor.x = Qt.binding(getRectanglePosition)
			cursorImage.x = Qt.binding(getImagePosition)
			cursorRectangle.visible = Qt.binding(isVisible)
		}

		onPlaybackStateChanged: {
			if (playbackController.state != PlaybackState.Recording && 
				playbackController.sample > context.sequenceDuration) {
				playbackController.sample = context.sequenceDuration
			}
		}
	}

	Connections {
		target: context
		ignoreUnknownSignals: true

		onSequenceDurationChanged: {
			if (playbackController.state != PlaybackState.Recording && 
				playbackController.sample > context.sequenceDuration) {
				playbackController.sample = context.sequenceDuration
			}
		}
	}
}
