import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.AnimSequences 1.0 as Sequences
import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.Buttons 1.0

AnimationButton {
	id: button
	iconImage: Constants.iconRecordButton
	iconColor: "transparent"
	text: "Record"
	enabled: context.sequenceOpened

	onClicked: {
		if (context.playbackController.state != Sequences.PlaybackController.Recording)
			context.playbackController.state = Sequences.PlaybackController.Recording
		else
			context.playbackController.state = Sequences.PlaybackController.Paused
	}

	ToolTip.text: text
	ToolTip.visible: hovered
	ToolTip.delay: ControlsSettings.tooltipDelay
	ToolTip.timeout: ControlsSettings.tooltipTimeout

	Binding on checked {
		value: context.playbackController.state == Sequences.PlaybackController.Recording
	}

	Connections {
		target: context.timelineActionManager
		onToggleRecordState: button.clicked()
	}
}
