import QtQuick 2.11
import QtQuick.Layouts 1.4
import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.Timeline 1.0

Item {
	id: root

	property var context

	ColumnLayout {
		id: layout
		width: parent.width
		height: parent.height
		spacing: 0

		RowLayout {
			id: playbackScaleLayout
			spacing: timelineSplitter.width

			Layout.fillWidth: true

			TrackPlayback {
				playbackController: context.playbackController
				timelineController: context.timelineController
				treeAdapter: sequenceTree.adapter
				disabled: context.sequenceOpened

				Layout.preferredWidth: timelineSplitter.x
			}

			TimelineScale {
				id: timelineScale
				model: context.timelineController.scaleModel
				cursorEnabled: context.sequenceOpened

				Layout.fillWidth: true

				Binding {
					target: context.timelineController
					property: "controlSize"
					value: Math.max(timelineScale.width, 0)
				}
			}
		}

		///////////////////////////////////////////////////////////////////

		SequenceTree {
			id: sequenceTree
			rootContext: context
			model: context.sequenceModel
			selectionModel: context.selectionModel

			Layout.fillWidth: true
			Layout.fillHeight: true
		}
	}

	Component.onCompleted: {
		Helpers.focusSequence(context)
	}
}
