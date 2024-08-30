import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQml 2.2
import QtQml.Models 2.2

import QtQuick.Controls 1.4
import QtQuick.Window 2.2

import PlaybackState 1.0

import "Helpers.js" as Helpers
import "Constants.js" as Constants

Rectangle {
	id: root

	property alias mainWindow: root

	color: _palette.panelBackground

	property real separatorPos: splitter.x + Math.round(splitter.width / 2)
	property real separatorWidth: 1

	TimelineShortcuts {
		id: shortcuts

		onPlaybackShortcutActivated: {
			if (timelineContext.playbackController.state == PlaybackState.Playing) {
				timelineContext.playbackController.pause()
			}
			else {
				timelineContext.playbackController.play()
			}
		}

		//onSaveShortcutActivated: timelineContext.saveSequence()
		onRecordShortcutActivated: timelineContext.playbackController.record()
		onStopShortcutActivated:  timelineContext.playbackController.stop()
		onFirstFrameShortcutActivated: timelinePlayback.goToFirstFrame()
		onLastFrameShortcutActivated: timelinePlayback.goToLastFrame()
		onAddKeyShortcutActivated: {
			if (timelineContext.playbackController.state != PlaybackState.Playing) {
				timelineContext.sequenceTreeModel.addKeyToSelection(
					timelineContext.keySelectionModel.selection)
			}
		}
		//onOpenShortcutActivated: timelineContext.openSequence()
		onZoomOutActivated: sequenceTree.zoomShortcutActivated(-120)
		onZoomInActivated: sequenceTree.zoomShortcutActivated(120)
		onNextKeyShortcutActivated: timelinePlayback.goToNextFrame()
		onPrevKeyShortcutActivated: timelinePlayback.goToPrevFrame()
		onRemoveKeyShortcutActivated: sequenceTree.deleteIndices()
	}

	Binding {
		target: timelineContext.timelineController
		property: "controlSize"
		value: Math.max(timelineScale.width, 0)
	}

	TimelineToolbar {
		id: timelineToolbar

		context: timelineContext

		width: parent.width
	}

	RowLayout {
		id: playbackScaleLayout

		spacing: root.separatorWidth
		width: parent.width

		anchors.top: timelineToolbar.bottom

		TimelinePlayback {
			id: timelinePlayback

			playbackController: timelineContext.playbackController
			timelineController: timelineContext.timelineController
			treeAdapter: sequenceTree.adapter
			disabled: timelineContext.sequenceOpened
			
			Layout.preferredWidth: root.separatorPos
		}

		TimelineScale {
			id: timelineScale

			model: timelineContext.timelineController.scaleModel
			cursorEnabled: timelineContext.sequenceOpened

			anchors.leftMargin: root.separatorWidth
			clip: true

			Layout.fillWidth: true
		}
	}

	RowLayout{
		id: eventRowLayout
		objectName: "eventRowLayout"

		spacing: root.separatorWidth
		width: parent.width

		anchors.top: playbackScaleLayout.bottom

		SequenceSaveLoad {
			Layout.preferredWidth: root.separatorPos
			implicitHeight: Constants.timelineEventHeight

			context: timelineContext
		}

		Rectangle {
			color: "black"
			border.color: Constants.labelBorderColor

			implicitHeight: Constants.timelineEventHeight
			Layout.fillWidth: true
			clip: true
		}
	}

	///////////////////////////////////////////////////////////////////

	SequenceTree {
		id: sequenceTree
	 	treeColumnWidth: root.separatorPos
		spacing: root.separatorWidth
		clip: true

		timelineController: timelineContext.timelineController
		rootContext: timelineContext
		model: timelineContext.sequenceTreeModel
		selectionModel: timelineContext.keySelectionModel

		rowDelegate: Rectangle {
			color: styleData.alternative ? Constants.seqTreeEvenItemColor : Constants.seqTreeOddItemColor 
		}

		anchors {
			bottom: parent.bottom
			left: parent.left
			right: parent.right
			top: eventRowLayout.bottom
		}

		onTryPlaceKey: {
			timelineContext.sequenceTreeModel.addKey(index, frameInSeconds)
		}

		onDeleteItems: {
			timelineContext.sequenceTreeModel.deleteItems(indices)
		}

		onMoveKey: {
			timelineContext.sequenceTreeModel.moveKey(index, newStartTime)
		}
	}

	Rectangle {
		id: splitterRect

		anchors.top : eventRowLayout.top
		anchors.bottom: parent.bottom

		x: root.separatorPos
		width: root.separatorWidth
		color: "black"
	}

	MouseArea {
		id: splitter

		width: 20
		x: drag.minimumX
		cursorShape: Qt.SizeHorCursor
		hoverEnabled: true
		preventStealing: true

		anchors.top: timelineToolbar.bottom
		anchors.bottom: parent.bottom

		drag.target: splitter
		drag.axis: Drag.XAxis
		drag.minimumX: timelinePlayback.minWidth
		drag.maximumX: Math.max(0, root.width - width)
	}

	Item {
		anchors.left: splitterRect.right
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		anchors.top: eventRowLayout.top

		clip: true

		TimelineCursorExt {
			visible: timelineContext.sequenceOpened

			timelineController: timelineContext.timelineController
			playbackController: timelineContext.playbackController

			anchors.top: parent.top
			anchors.bottom: parent.bottom
		}
	}

	Component.onCompleted: {
			Helpers.focusSequence(timelineContext)
	}
}
