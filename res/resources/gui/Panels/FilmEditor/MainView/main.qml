import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

import WGTools.ControlsEx 1.0 as ControlsEx
import Panels.SequenceTimeline 1.0

ControlsEx.Panel {
	id: root

	property var rootContext: context

	title: "Filmmaker"
	layoutHint: "center"

	ColumnLayout {
		width: parent.width
		height: parent.height
		spacing: 0

		ReplayTimeline {
			context: rootContext.replayTimelineContext

			Layout.fillWidth: true
			Layout.preferredHeight: 100
		}

		TrackTimeline {
			context: rootContext.filmtrackTimelineContext

			Layout.fillWidth: true
			Layout.fillHeight: true
		}
	}

	Splitter {
		id: timelineSplitter
		height: parent.height
		minPosition: Constants.minTreeViewWidth
		maxPosition: Math.max(0, parent.width - width)
	}
}
