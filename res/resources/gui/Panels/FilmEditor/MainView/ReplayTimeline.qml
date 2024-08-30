import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQml 2.2
import QtQml.Models 2.2

import QtQuick.Controls 1.4
import QtQuick.Window 2.2

import WGTools.Styles.Text 1.0 as WGText
import WGTools.Controls 2.0 as WGControls

import "../../SequenceTimeline/Helpers.js" as Helpers
import "../../SequenceTimeline/Constants.js" as Constants
import "../../SequenceTimeline"
import "../../SequenceTimeline/Buttons"


Rectangle {
	id: root

	property var context

	property alias mainWindow: root

	property real separatorPos: splitter.x + Math.round(splitter.width / 2)
	property real separatorWidth: 1

	Binding {
		target: context.timelineController
		property: "controlSize"
		value: Math.max(timelineScale.width, 0)
	}

	RowLayout {
		id: playbackScaleLayout

		spacing: root.separatorWidth
		width: parent.width


		ReplayPlayback{
			Layout.preferredWidth: root.separatorPos
			Layout.fillHeight: true
		}

		TimelineScale {
			id: timelineScale

			model: context.timelineController.scaleModel
			cursorEnabled: context.sequenceOpened

			anchors.leftMargin: root.separatorWidth
			clip: true

			Layout.fillWidth: true


			Rectangle {
				id: replayDuration

				width: getWidth()
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.margins: 1

				x: context.timelineController.fromValueToPixels(0)

				color: Qt.rgba(0, 1, 0, 0.2)

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
		treeColumnWidth: root.separatorPos
		spacing: root.separatorWidth
		clip: true

		timelineController: context.timelineController
		rootContext: context
		//selectionModel: context.selectionModel

		anchors {
			bottom: parent.bottom
			left: parent.left
			right: parent.right
			top: playbackScaleLayout.bottom
		}

		ColumnLayout
		{
			width: root.separatorPos
			height: parent.height

			WGText.BaseRegular{
				Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
				Layout.topMargin: 10
				Layout.bottomMargin: 0

				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter

				text: context.replayName
			}

			WGControls.Button
			{
				Layout.alignment: Qt.AlignHCenter
				Layout.topMargin: 0
				Layout.bottomMargin: 10

				text: "choose..."
				enabled: context.canChangeReplay

				onClicked: context.chooseReplay()
			}

		}
	}

	Rectangle {
		id: splitterRect

		anchors.top : playbackScaleLayout.top
		anchors.bottom: parent.bottom

		x: root.separatorPos
		width: root.separatorWidth
		color: "black"
	}


	Item {
		anchors.left: splitterRect.right
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		anchors.top: playbackScaleLayout.top

		clip: true

		TimelineCursorExt {
			visible: context.sequenceOpened

			timelineController: context.timelineController
			playbackController: context.playbackController

			anchors.top: parent.top
			anchors.bottom: parent.bottom
		}
	}

	Component.onCompleted: {
		Helpers.focusSequence(context)
	}
}
