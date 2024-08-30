import QtQuick 2.11
import QtQuick.Layouts 1.4
import Panels.SequenceTimeline.Tree 1.0
import Panels.SequenceTimeline.Timeline 1.0

Rectangle {
	implicitHeight: layout.implicitHeight
	color: _palette.color9

	RowLayout {
		id: layout
		width: parent.width
		spacing: timelineSplitter.width

		TreeHeader {
			Layout.preferredWidth: timelineSplitter.x
			Layout.fillHeight: true
		}

		TimelineScale {
			id: timelineScale
			model: context.timelineController.scaleModel
			cursorEnabled: context.sequenceOpened

			Layout.fillWidth: true
			Layout.fillHeight: true

			Binding {
				target: context.timelineController
				property: "controlSize"
				value: Math.max(timelineScale.width, 0)
			}
		}
	}
}
