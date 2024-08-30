import QtQuick 2.11
import Panels.SequenceTimeline 1.0
import WGTools.AnimSequences 1.0 as Sequences

TimelineToolButton {
	id: button

	property bool isPlaying: context.playbackController.state == Sequences.PlaybackController.Playing

	enabled: context.sequenceOpened
	text: "Play"
	iconImage: isPlaying ? Constants.iconPauseButton : Constants.iconPlayButton

	onClicked: {
		if (!isPlaying)
			context.playbackController.state = Sequences.PlaybackController.Playing
		else
			context.playbackController.state = Sequences.PlaybackController.Paused
	}

	Connections {
		target: context.playbackController
		ignoreUnknownSignals: true
		onStateChanged: {
			switch (context.playbackController.state) {
			case Sequences.PlaybackController.Playing:
				button.isPlaying = true
				button.iconImage = Constants.iconPauseButton
				break
			case Sequences.PlaybackController.Paused:
				button.isPlaying = false;
				button.iconImage = Constants.iconPlayButton
				break
			case Sequences.PlaybackController.Recording:
				button.isPlaying = false;
				button.iconImage = Constants.iconPlayButton
				break
			}
		}
	}

	Connections {
		target: context.timelineActionManager
		onTogglePlaybackState: button.clicked()
	}
}
