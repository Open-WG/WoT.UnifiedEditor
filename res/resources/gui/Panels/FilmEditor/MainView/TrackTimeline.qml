import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQml 2.2
import QtQml.Models 2.2

import QtQuick.Controls 1.4
import QtQuick.Window 2.2

import "../../SequenceTimeline/Helpers.js" as Helpers
import "../../SequenceTimeline/Constants.js" as Constants
import "../../SequenceTimeline"


Rectangle {
	id: root

	property var context
	property alias context: root.context

	property alias mainWindow: root
	property alias minSplitterPos: timelinePlayback.minWidth

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

		TrackPlayback {
			id: timelinePlayback

			playbackController: context.playbackController
			timelineController: context.timelineController
			treeAdapter: sequenceTree.adapter
			disabled: context.sequenceOpened

			Layout.preferredWidth: root.separatorPos
		}

		TimelineScale {
			id: timelineScale

			model: context.timelineController.scaleModel
			cursorEnabled: context.sequenceOpened

			anchors.leftMargin: root.separatorWidth
			clip: true

			Layout.fillWidth: true
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
		model: context.sequenceModel
		selectionModel: context.selectionModel

		rowDelegate: Rectangle {
			color: styleData.alternative ? Constants.seqTreeEvenItemColor : Constants.seqTreeOddItemColor
		}

		anchors {
			bottom: parent.bottom
			left: parent.left
			right: parent.right
			top: playbackScaleLayout.bottom
		}

		onMoveKey: {
			context.sequenceModel.moveKey(index, newStartTime)
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
