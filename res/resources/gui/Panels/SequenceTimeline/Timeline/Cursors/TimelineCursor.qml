import QtQuick 2.11
import Panels.SequenceTimeline 1.0

TimelineBaseCursor {
	id: cursor
	color: Constants.playbackCursorColor
	visible: context.sequenceOpened

	function getPosition() {
		if (context.playbackController)
			return Math.round(context.timelineController.fromSecondsToScale(context.playbackController.sample))

		return 0
	}

	Binding on x { value: cursor.getPosition() }
	Connections {
		target: context.timelineController
		ignoreUnknownSignals: false
		onScaleChanged: cursor.x = cursor.getPosition()
	}
}
