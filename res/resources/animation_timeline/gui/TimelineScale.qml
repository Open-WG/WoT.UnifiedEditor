import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import PlaybackState 1.0

import "Constants.js" as Constants
import "Helpers.js" as Helpers
import "Debug"

Item {
	id: root

	property alias model: repeater.model
	property alias cursorEnabled: timelineCursor.visible

	implicitHeight: Constants.timelineScaleHeight

	Rectangle {
		id: scale
		color: timelineContext.playbackController.state == PlaybackState.Recording
			? Constants.scaleBackgroundRecordingColor : Constants.scaleBackgoundColor

		anchors.fill: parent
		border.width: 1
		border.color: "black"

		Rectangle {
			width: scale.border.width
			height: parent.height - scale.border.width * 2
			y: parent.border.width
			color: parent.color
		}

		Rectangle {
			id: sequenceDuration

			width: getWidth()
			anchors.margins: scale.border.width
			anchors.top: parent.top
			anchors.bottom: parent.bottom

			x: timelineContext.timelineController.fromScaleToScreen(0)

			color: timelineContext.playbackController.state == PlaybackState.Recording 
				? Constants.sequenceDurationRecordingColor : Constants.sequenceDurationColor
			opacity: 0.6

			function getWidth() {
				var seqDuration = timelineContext.timelineController.fromSecondsToFrames(timelineContext.sequenceDuration)
				return timelineContext.timelineController.fromScaleToScreen(seqDuration) - x
			}

			Connections {
				target: timelineContext.timelineController
				ignoreUnknownSignals: true
				onScaleChanged: {
					sequenceDuration.x = timelineContext.timelineController.fromScaleToScreen(0)
				}
			}

			Connections {
				target: timelineContext
				ignoreUnknownSignals: true
				onSequenceChanged: {
					if (root.width)
						Helpers.focusSequence(timelineContext)
				}
			}
		}

		TimelineCursor {
			id: timelineCursor

			width: 2
			height: 2

			anchors.leftMargin: root.spacing
			timelineController: timelineContext.timelineController
			playbackController: timelineContext.playbackController
			context: timelineContext
		}

		Repeater {
			id: repeater

			delegate: Rectangle {
				height: Constants.strokeHeight * model.majorityCoeff
				width: Constants.strokeWidth

				x: Math.round(model.position)

				anchors.bottom : parent.bottom
				anchors.alignWhenCentered: false

				color: "black"
				opacity: model.majorityCoeff

				Text {
					property int frame: model.value

					y: -parent.height / 5.0
					x: 3

					visible: model.majorityCoeff == 1 ? true : false

					text: timelineContext.timelineController.getReadableRepresentationFromFrame(frame)

					font.family: Constants.proximaRg
					font.pixelSize: 10
					font.bold: true
				}
			}
		}

		MouseArea {
			property var timelineController : timelineContext.timelineController
			property var playbackController : timelineContext.playbackController
			property bool isReleased: true

			anchors.fill: parent

			function setNewSample(mouseX) {
				var frame = timelineController.fromScreenToScaleClipped(mouseX)
				var newVal = timelineController.fromFramesToSeconds(frame)

				playbackController.currentSample = (newVal > timelineContext.sequenceDuration && playbackController.state != PlaybackState.Recording)
					? timelineContext.sequenceDuration
					: newVal
			}

			onPressed: {
				isReleased = false

				setNewSample(mouse.x)
			}

			onReleased: {
				isReleased = true
			}

			onPositionChanged: {
				if (!isReleased) {
					setNewSample(mouse.x)
				}
			}
		}
	}
}
