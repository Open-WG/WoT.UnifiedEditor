import QtQuick 2.11
import WGTools.Controls 2.0
import Panels.SequenceTimeline 1.0
import WGTools.AnimSequences 1.0 as Sequences

TimelineToolButton {
	id: button
	enabled: context.sequenceOpened
	text: "Start"
	iconImage: Constants.iconFirstFrameButton

	ToolTip.text: "First frame"

	onClicked: {
		var cursorLocation = context.playbackController.sample
		context.timelineLimitController.leftBorder = 0 

		context.playbackController.state = Sequences.PlaybackController.Paused
		if (context.timelineController.isSecondVisible(cursorLocation)) {
			context.timelineController.focusAroundSecond(0)
			context.playbackController.sample = 0
		} else {
			context.timelineController.focusAroundSecond(cursorLocation)
		}
	}

	Connections {
		target: context.timelineActionManager
		onScrollToTheBeginning: button.clicked()
	}
}
