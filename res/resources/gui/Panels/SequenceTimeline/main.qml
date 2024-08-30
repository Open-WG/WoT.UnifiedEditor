import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQml 2.2
import QtQml.Models 2.2

import QtQuick.Controls 1.4
import QtQuick.Window 2.2

import WGTools.ControlsEx 1.0 as ControlsEx

import "Helpers.js" as Helpers
import "Constants.js" as Constants

ControlsEx.Panel {
	id: animationSequence
	title: "Sequence Timeline"
	Accessible.name: title
	layoutHint: "bottom"

	Rectangle {
		id: root

		property alias mainWindow: root

		property real separatorPos: splitter.x + Math.round(splitter.width / 2)
		property real separatorWidth: 1

		anchors.fill: parent

		Binding {
			target: context.timelineController
			property: "controlSize"
			value: Math.max(timelineScale.width, 0)
		}

		TimelineToolbar {
			id: timelineToolbar

			width: parent.width
		}

		RowLayout {
			id: playbackScaleLayout

			spacing: root.separatorWidth
			width: parent.width

			anchors.top: timelineToolbar.bottom

			TimelinePlayback {
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

		RowLayout{
			id: eventRowLayout
			objectName: "eventRowLayout"

			spacing: root.separatorWidth
			width: parent.width

			anchors.top: playbackScaleLayout.bottom

			SequenceSaveLoad {
				Layout.preferredWidth: root.separatorPos
				implicitHeight: Constants.timelineEventHeight
			}

			Rectangle {
				color: "black"
				border.color: Constants.labelBorderColor

				implicitHeight: Constants.timelineEventHeight
				Layout.fillWidth: true
				clip: true
			}
		}

		SequenceTree {
			id: sequenceTree
			treeColumnWidth: root.separatorPos
			spacing: root.separatorWidth
			clip: true
			focus: true

			timelineController: context.timelineController
			rootContext: context
			model: context.sequenceModel
			selectionModel: context.selectionModel

			rowDelegate: Rectangle {
				color: styleData.rowSelected ? _palette.color12 : // selected/highlighted color
				styleData.alternative ? Constants.seqTreeEvenItemColor : Constants.seqTreeOddItemColor 
			}

			anchors {
				bottom: parent.bottom
				left: parent.left
				right: parent.right
				top: eventRowLayout.bottom
			}

			onMoveKey: {
				context.sequenceModel.moveKey(index, newStartTime)
			}
		}

		Rectangle {
			id: splitterRect

			anchors.top : eventRowLayout.top
			anchors.bottom: parent.bottom

			x: root.separatorPos
			width: root.separatorWidth
			color: Constants.splitterColor
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
			id: timelineArea
			anchors.left: splitterRect.right
			anchors.bottom: parent.bottom
			anchors.right: parent.right
			anchors.top: eventRowLayout.top

			clip: true
			focus: context.insertingNodes

			TimelineCursorExt {
				visible: context.sequenceOpened

				timelineController: context.timelineController
				playbackController: context.playbackController

				anchors.top: parent.top
				anchors.bottom: parent.bottom
			}

			TimelineCursorToInsert {
				visible: context.insertingNodes

				timelineController: context.timelineController
				playbackController: context.playbackController
				mouseCursorPosX: insertArea.mouseX

				anchors.top: parent.top
				anchors.bottom: parent.bottom
			}

			MouseArea {
				id: insertArea

				property var timelineController: context.timelineController

				anchors.top: parent.top
				anchors.left: parent.left

				width : context.insertingNodes ? parent.width : 1
				height : context.insertingNodes ? parent.height : 1

				enabled: context.insertingNodes
				hoverEnabled: true

				onReleased: {
					context.insertingNodes = false

					var frame = timelineController.fromScreenToScaleClipped(mouse.x)
					var newVal = timelineController.fromFramesToSeconds(frame)

					context.pasteCopiedNodesFromTheBuffer(newVal)
				}
			}

			// Ensure that we get escape key press events first.
			Keys.onShortcutOverride: event.accepted = (event.key === Qt.Key_Escape)
			Keys.onEscapePressed: {
				context.insertingNodes = false

				event.accepted = true
			}
		}

		Timer {
			id: focusTimer

			interval: 10
			repeat: false
			running: false

			onTriggered: Helpers.focusSequence(context)
		}

		Component.onCompleted: {
			focusTimer.running = true
		}
	}
}