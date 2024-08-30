import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

import WGTools.ControlsEx 1.0 as ControlsEx
import "../../SequenceTimeline"


ControlsEx.Panel {
	id: root
	title: "Filmmaker"
	layoutHint: "center"

	property var rootContext : context

	ReplayTimeline {
		id: replayTimeline
		anchors.left: root.left
		anchors.right: root.right
		height: 100

		context : rootContext.replayTimelineContext
	}

	TrackTimeline {
		id: trackTimeline

		anchors.top: replayTimeline.bottom
		anchors.bottom: root.bottom
		anchors.left: root.left
		anchors.right: root.right

		context : rootContext.filmtrackTimelineContext
	}

	MouseArea {
		id: splitter

		width: 20
		x: drag.minimumX
		cursorShape: Qt.SizeHorCursor
		hoverEnabled: true
		preventStealing: true

		anchors.top: replayTimeline.top
		anchors.bottom: parent.bottom

		drag.target: splitter
		drag.axis: Drag.XAxis
		drag.minimumX: trackTimeline.minSplitterPos
		drag.maximumX: Math.max(0, root.width - width)
	}
}
