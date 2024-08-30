import QtQuick 2.11
import WGTools.Controls 2.0
import Panels.SequenceTimeline 1.0
import WGTools.AnimSequences 1.0 as Sequences

TimelineToolButton {
	id: button
	enabled: context.sequenceOpened
	text: "End"
	iconImage: Constants.iconLastFrameButton

	ToolTip.text: "Last frame"

	onClicked: {
		var cursorLocation = context.playbackController.sample
		context.timelineLimitController.rightBorder = Math.round(context.sequenceModel.sequenceDuration * context.frameRate) 

		context.playbackController.state = Sequences.PlaybackController.Paused
		if (context.timelineController.isSecondVisible(cursorLocation)) {
			context.timelineController.focusAroundSecond(context.sequenceModel.sequenceDuration)
			context.playbackController.sample = context.sequenceModel.sequenceDuration
		} else {
			context.timelineController.focusAroundSecond(cursorLocation)
		}
	}

	Connections {
		target: context.timelineActionManager
		onScrollToTheEnd: button.clicked()
	}
}
