import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import WGTools.AnimSequences 1.0 as Sequences

import "Constants.js" as Constants
import "Helpers.js" as Helpers

Item {
	id: root

	property alias model: repeater.model
	property alias cursorEnabled: timelineCursor.visible

	implicitHeight: Constants.timelineScaleHeight

	Rectangle {
		id: scale
		color: context.playbackController.state == Sequences.PlaybackController.Recording
			? Constants.scaleBackgroundRecordingColor : Constants.scaleBackgroundColor
		
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

			x: context.timelineController.fromValueToPixels(0)

			color: context.playbackController.state == Sequences.PlaybackController.Recording 
				? Constants.sequenceDurationRecordingColor : Constants.sequenceDurationColor
			opacity: 0.6

			function getWidth() {
				if (!context.sequenceModel)
				{
					return 0;
				}
				var seqDuration = context.timelineController.fromSecondsToFrames(context.sequenceModel.sequenceDuration)
				return context.timelineController.fromValueToPixels(seqDuration) - x
			}

			Connections {
				target: context.timelineController
				ignoreUnknownSignals: true
				onScaleChanged: {
					sequenceDuration.x = context.timelineController.fromValueToPixels(0)
					sequenceDuration.width = sequenceDuration.getWidth()
				}
			}

			Connections {
				target: context.sequenceModel
				ignoreUnknownSignals: true
				onSequenceDurationChanged: {
					sequenceDuration.x = context.timelineController.fromValueToPixels(0)
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

		TimelineCursor {
			id: timelineCursor

			width: 2
			height: 2

			anchors.leftMargin: root.spacing
			timelineController: context.timelineController
			playbackController: context.playbackController
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

					anchors.bottom : parent.bottom
					anchors.alignWhenCentered: false

					color: "black"
					opacity: model.majorityCoeff

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
			Accessible.name: "Scale"

			property var timelineController: context.timelineController
			property var playbackController: context.playbackController
			property bool isReleased: true

			anchors.fill: parent

			function setNewSample(mouseX) {
				var frame = timelineController.fromScreenToScaleClipped(mouseX)
				var newVal = timelineController.fromFramesToSeconds(frame)

				if (!context.sequenceModel)
				{
					playbackController.sample = newVal;
					return;
				}

				playbackController.sample =
					(newVal > context.sequenceModel.sequenceDuration
						&& playbackController.state != Sequences.PlaybackController.Recording)
					? context.sequenceModel.sequenceDuration
					: newVal
			}

			onPressed: {
				isReleased = false

				setNewSample(mouse.x)
			}

			onReleased: { isReleased = true }

			onPositionChanged: {
				if (!isReleased) 
					setNewSample(mouse.x)
			}
		}
	}
}
