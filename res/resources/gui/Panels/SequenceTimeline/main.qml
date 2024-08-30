import QtQuick 2.11
import QtQuick.Layouts 1.4
import WGTools.ControlsEx 1.0
import Panels.SequenceTimeline.Timeline 1.0
import Panels.SequenceTimeline.Comments 1.0

import "Toolbar"
import "Helpers.js" as Helpers
import "Constants.js" as Constants

Panel {
	id: root
	title: "Sequence Timeline"
	layoutHint: "bottom"

	CommentsCommonData {
		id: commentsCommonData
	}

	ColumnLayout {
		width: parent.width
		height: parent.height
		spacing: 0

		TimelineToolbar {
			treeAdapter: sequenceTree.adapter
			curveView: sequenceTree.curvesView
			curveActions: sequenceTree.curveActions

			Layout.fillWidth: true
		}

		Item {
			Layout.fillWidth: true
			Layout.fillHeight: true

			ColumnLayout {
				width: parent.width
				height: parent.height
				spacing: 0

				Header {
					Layout.fillWidth: true
				}

				SequenceTree {
					id: sequenceTree
					focus: true

					rootContext: context
					model: context.sequenceModel
					selectionModel: context.selectionModel

					Layout.fillWidth: true
					Layout.fillHeight: true

					draggingEnabled: true
				}

				Footer {
					Layout.fillWidth: true
				}
			}

			TimelineInsertionArea {
				anchors.fill: parent
				anchors.leftMargin: timelineSplitter.x + timelineSplitter.width
			}

			Splitter {
				id: timelineSplitter
				height: parent.height
				minPosition: Constants.minTreeViewWidth
				maxPosition: Math.max(0, parent.width - width)
			}
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
