import QtQuick 2.11
import WGTools.Controls 2.0
import Panels.SequenceTimeline 1.0
import WGTools.AnimSequences 1.0 as Sequences

TimelineToolButton {
	id: button
	enabled: context.sequenceOpened
	text: "Next K"
	iconImage: Constants.iconNextFrameButton

	ToolTip.text: "Next Key"

	onClicked: {
		context.playbackController.state = Sequences.PlaybackController.Paused
		context.playbackController.sample = treeAdapter.getNextKeySample(context.playbackController.sample)
		
		var framesValue = Math.round(context.playbackController.sample * context.frameRate)
		if (context.timelineLimitController.rightBorder < framesValue) {
			context.timelineLimitController.rightBorder = framesValue
		} 
		// TODO remove next else if when current frame will be equal 
		// to the Start in Loop Range value after editing it
		else if (context.timelineLimitController.leftBorder > framesValue) {
			context.timelineLimitController.leftBorder = framesValue
		}


		context.timelineController.focusAroundSecond(context.playbackController.sample)
	}

	Connections {
		target: context.timelineActionManager
		onNextKey: button.clicked()
	}
}
