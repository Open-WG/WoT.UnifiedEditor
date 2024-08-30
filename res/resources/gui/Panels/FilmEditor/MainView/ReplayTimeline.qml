import QtQuick 2.11
import QtQuick.Layouts 1.4
import WGTools.Styles.Text 1.0 as WGText
import WGTools.Controls 2.0 as WGControls
import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.Timeline 1.0

Item {
	id: root

	property var context

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight

	ColumnLayout {
		id: layout
		width: parent.width
		height: parent.height
		spacing: 0

		RowLayout {
			id: playbackScaleLayout
			spacing: timelineSplitter.width

			Layout.fillWidth: true

			ReplayPlayback {
				Layout.preferredWidth: timelineSplitter.x
				Layout.fillHeight: true
			}

			TimelineScale {
				id: timelineScale
				model: context.timelineController.scaleModel
				cursorEnabled: true// context.sequenceOpened

				Layout.fillWidth: true

				Binding {
					target: context.timelineController
					property: "controlSize"
					value: Math.max(timelineScale.width, 0)
				}

				Rectangle {
					id: replayDuration
					width: getWidth()
					color: Qt.rgba(0, 1, 0, 0.2)
					x: context.timelineController.fromValueToPixels(0)

					anchors.top: parent.top
					anchors.bottom: parent.bottom
					anchors.margins: 1

					function getWidth() {
						var replayLength = context.playbackController.replayLength;
						var seqDuration = context.timelineController.fromSecondsToFrames(replayLength);
						return context.timelineController.fromValueToPixels(seqDuration) - x;
					}

					Connections {
						target: context.timelineController
						ignoreUnknownSignals: true
						onScaleChanged: {
							replayDuration.x = context.timelineController.fromValueToPixels(0)
						}
					}
				}
			}
		}

		///////////////////////////////////////////////////////////////////

		SequenceTree {
			id: sequenceTree
			rootContext: context
			selectionModel: context.selectionModel

			Layout.fillWidth: true
			Layout.fillHeight: true

			ColumnLayout {
				width: timelineSplitter.x
				height: parent.height

				WGText.BaseRegular{
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
					text: context.replayName

					Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
					Layout.topMargin: 10
					Layout.bottomMargin: 0
				}

				WGControls.Button {
					text: "choose..."
					enabled: context.canChangeReplay

					Layout.alignment: Qt.AlignHCenter
					Layout.topMargin: 0
					Layout.bottomMargin: 10

					onClicked: context.chooseReplay()
				}
			}
		}
	}

	Component.onCompleted: {
		Helpers.focusSequence(context)
	}
}
