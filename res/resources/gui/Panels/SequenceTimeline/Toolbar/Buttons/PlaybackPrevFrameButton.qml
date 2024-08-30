import QtQuick 2.11
import WGTools.Controls 2.0
import Panels.SequenceTimeline 1.0
import WGTools.AnimSequences 1.0 as Sequences

TimelineToolButton {
	id: button
	enabled: context.sequenceOpened
	text: "Prev K"
	iconImage: Constants.iconPrevFrameButton

	ToolTip.text: "Previous Key"

	onClicked: {
		context.playbackController.state = Sequences.PlaybackController.Paused
		context.playbackController.sample = treeAdapter.getPrevKeySample(context.playbackController.sample)
		
		var framesValue = Math.round(context.playbackController.sample * context.frameRate)
		if (context.timelineLimitController.leftBorder > framesValue) {
			context.timelineLimitController.leftBorder = framesValue
		}
		
		context.timelineController.focusAroundSecond(context.playbackController.sample)
	}

	Connections {
		target: context.timelineActionManager
		onPreviousKey: button.clicked()
	}
}
