import QtQuick 2.11
import Panels.SequenceTimeline 1.0
import WGTools.AnimSequences 1.0 as Sequences

TimelineToolButton {
	id: button
	enabled: context.sequenceOpened
	text: "Stop"
	iconImage: Constants.iconStopButton

	onClicked: {
		context.playbackController.state = Sequences.PlaybackController.Paused
		var leftBorderSample = context.timelineController.fromFramesToSeconds(context.timelineLimitController.leftBorder)
		context.playbackController.sample = leftBorderSample
	}

	Connections {
		target: context.timelineActionManager
		onStopPlayback: button.clicked()
	}
}
