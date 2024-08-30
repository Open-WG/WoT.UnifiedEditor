import QtQuick 2.11
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.4
import WGTools.AnimSequences 1.0 as Sequences
import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.Timeline 1.0

Item {
	id: root

	property alias model: repeater.model
	property alias cursorEnabled: timelineCursor.visible
	property var recordingEnabled: context.playbackController.state == Sequences.PlaybackController.Recording

	implicitHeight: Constants.timelineScaleHeight
	clip: true

	Rectangle {
		id: scale
		color: recordingEnabled ? Constants.scaleBackgroundRecordingColor : Constants.scaleBackgroundColor
		
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
			color: recordingEnabled ? Constants.sequenceDurationRecordingColor : Constants.sequenceDurationColor
			opacity: recordingEnabled ? 0.6 : 0.2
			visible: context.sequenceOpened

			anchors.margins: scale.border.width
			anchors.top: parent.top
			anchors.bottom: parent.bottom

			function getX() {
				return context.timelineController.fromValueToPixels(0)
			}

			function getWidth() {
				if (!context.sequenceModel) {
					return 0;
				}
				var seqDuration = context.timelineController.fromSecondsToFrames(context.sequenceModel.sequenceDuration)
				return context.timelineController.fromValueToPixels(seqDuration) - x
			}

			Binding on x { value: sequenceDuration.getX() }
			Binding on width { value: sequenceDuration.getWidth() }

			Connections {
				target: context.timelineController
				ignoreUnknownSignals: true
				onScaleChanged: {
					sequenceDuration.x = sequenceDuration.getX()
					sequenceDuration.width = sequenceDuration.getWidth()
				}
			}

			Connections {
				target: context.sequenceModel
				ignoreUnknownSignals: true
				onSequenceDurationChanged: {
					sequenceDuration.x = sequenceDuration.getX()
					sequenceDuration.width = sequenceDuration.getWidth()
				}
			}

			Connections {
				target: context
				ignoreUnknownSignals: true
				onSequenceChanged: {
					if (context.timelineController.controlSize)
						Helpers.focusSequence(context)
				}

				onSequenceOpenedChanged: {
					if (context.timelineController.controlSize)
						Helpers.focusSequence(context)
				}
			}
		}

		Item {
			anchors.fill: parent
			visible: timelineCursor.visible

			Repeater {
				id: repeater
				
				delegate: Rectangle {
					height: Constants.strokeHeight * model.majorityCoeff
					width: Constants.strokeWidth
					x: Math.round(model.position)
					opacity: model.majorityCoeff
					color: "black"

					anchors.bottom : parent.bottom
					anchors.alignWhenCentered: false

					Text {
						property int frame: model.value

						y: -parent.height / 5.0
						x: 3
						visible: model.majorityCoeff == 1 ? true : false
						text: context.timelineController.getReadableRepresentationFromFrame(frame)

						font.family: Constants.proximaRg
						font.pixelSize: 10
						font.bold: true
					}
				}
			}
		}

		MouseArea {
			property var timelineController: context.timelineController
			property var playbackController: context.playbackController
			property bool isReleased: true

			anchors.fill: parent

			Accessible.name: "Scale"

			function setNewSample(mouseX) {
				var frame = timelineController.fromScreenToScaleClipped(mouseX)
				var newVal = timelineController.fromFramesToSeconds(frame)

				if (!context.sequenceModel) {
					playbackController.sample = newVal
					return
				}
				
				if (context.timelineLimitController) {
					newVal = Math.max(newVal, context.timelineLimitController.leftBorder / context.frameRate)
					if (!recordingEnabled) {
						newVal = Math.min(newVal, context.timelineLimitController.rightBorder / context.frameRate)
					}
				} else {
					if (!recordingEnabled) {
						newVal = Math.min(newVal, context.sequenceModel.sequenceDuration)
					}
				}

				playbackController.sample = newVal
			}

			onDoubleClicked: {
				timelineCursor.isInputVisible = true
			}

			onPressed: {
				isReleased = false
				setNewSample(mouse.x)
				timelineCursor.isInputVisible = false

				if (!root.recordingEnabled)
					playbackController.state = Sequences.PlaybackController.Paused
			}

			onReleased: {
				isReleased = true
			}

			onPositionChanged: {
				if (!isReleased) 
					setNewSample(mouse.x)
			}
		}

		TimelineGlobalCommentsMarkers {
			anchors.fill: parent
		}

		ScaleCursor {
			id: timelineCursor
			timelineController: context.timelineController
			playbackController: context.playbackController

			anchors.leftMargin: root.spacing
		}
	}
}
