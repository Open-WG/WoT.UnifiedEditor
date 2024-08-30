import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import WGTools.AnimSequences 1.0 as Sequences

import "Constants.js" as Constants
import "Effects"
import "Buttons"
import "Backgrounds"

Item {
	id: root

	readonly property alias minWidth: row.implicitWidth

	property var playbackController : null
	property var timelineController : null
	property var treeAdapter: null
	property bool disabled: false

	implicitHeight: Constants.timelineScaleHeight

	Rectangle {
		z: 100
		anchors.fill: parent
		anchors.rightMargin: -1

		color: "transparent"
		border.color: "black"
		border.width: 1
	}

	function goToFirstFrame() {
		var cursorLocation = playbackController.sample

		if (timelineController.isSecondVisible(cursorLocation)) {
			timelineController.focusAroundSecond(0)
			playbackController.sample = 0
		}
		else {
			timelineController.focusAroundSecond(cursorLocation)
		}
	}

	function goToLastFrame() {
		var cursorLocation = playbackController.sample

		if (timelineController.isSecondVisible(cursorLocation)) {
			timelineController.focusAroundSecond(context.sequenceModel.sequenceDuration)
			playbackController.sample = context.sequenceModel.sequenceDuration
		}
		else {
			timelineController.focusAroundSecond(cursorLocation)
		}
	}

	function goToPrevFrame() {
		playbackController.sample =
			treeAdapter.getPrevKeySample(playbackController.sample)
		timelineController.focusAroundSecond(playbackController.sample)
	}

	function goToNextFrame() {
		playbackController.sample =
			treeAdapter.getNextKeySample(playbackController.sample)
		timelineController.focusAroundSecond(playbackController.sample)
	}

	RowLayout {
		id: row
		spacing: 0
		anchors.fill: parent
		//anchors.rightMargin: -1

		Button {
			id: recordButton
			Accessible.name: "Record"

			property real imageSize: 12

			enabled: root.disabled

			hoverEnabled: true
			focusPolicy: Qt.NoFocus

			Layout.fillHeight: true
			Layout.fillWidth: true
			Layout.minimumWidth: Constants.playbackButtonMinWidth

			background: TimelineButtonBackground {
				borderRadius: 0
			}

			contentItem: Item {
				Rectangle {
					id: recordRect

					antialiasing: true

					anchors.alignWhenCentered: false
					anchors.centerIn: parent

					width: recordButton.imageSize
					height: width

					radius: width / 2

					color: "#b90000"

					opacity: enabled ? 1 : 0.25
				}
			}

			onClicked: {
				if (playbackController.state != Sequences.PlaybackController.Recording)
					playbackController.state = Sequences.PlaybackController.Recording
				else
					playbackController.state = Sequences.PlaybackController.Paused
			}

			BackAndForthAnimation {
				id: recordAnimation
				isRunning: false
				target: recordButton
				properties: "imageSize"
				from: 12
				to: 16
				upDuration: 600
				downDuration: 300
			}

			function stop() {
				recordAnimation.stop()
				recordButton.imageSize = 12
			}

			function start() {
				recordAnimation.start()
			}
		}

		TimelineButton {
			id: firstFrameButton
			Accessible.name: "First frame"

			enabled: root.disabled

			Layout.fillHeight: true
			Layout.fillWidth: true
			Layout.minimumWidth: Constants.playbackButtonMinWidth

			iconImage: Constants.iconFirstFrameButton
			iconImageSize.width: Constants.playbackIconWidth
			iconImageSize.height: Constants.playbackIconHeight

			borderRadius: 0

			onClicked: goToFirstFrame()
		}

		TimelineButton {
			id: prevFrameButton
			Accessible.name: "Previous frame"

			enabled: root.disabled

			Layout.fillHeight: true
			Layout.fillWidth: true
			Layout.minimumWidth: Constants.playbackButtonMinWidth

			iconImage: Constants.iconPrevFrameButton
			iconImageSize.width: Constants.playbackIconWidth
			iconImageSize.height: Constants.playbackIconHeight

			borderRadius: 0

			onClicked: goToPrevFrame()
		}

		TimelineButton {
			id: playButton
			Accessible.name: "Play"

			enabled: root.disabled

			property bool isPlaying: playbackController.state == Sequences.PlaybackController.Playing

			Layout.fillHeight: true
			Layout.fillWidth: true
			Layout.minimumWidth: Constants.playbackButtonMinWidth

			iconImage: isPlaying ? Constants.iconPauseButton : Constants.iconPlayButton
			iconImageSize.width: Constants.playbackIconWidth
			iconImageSize.height: Constants.playbackIconHeight

			borderRadius: 0

			onClicked: {
				if (!isPlaying)
					playbackController.state = Sequences.PlaybackController.Playing
				else
					playbackController.state = Sequences.PlaybackController.Paused
			}
		}

		TimelineButton {
			id: nextFrameButton
			Accessible.name: "Next frame"

			enabled: root.disabled

			Layout.fillHeight: true
			Layout.fillWidth: true
			Layout.minimumWidth: Constants.playbackButtonMinWidth

			iconImage: Constants.iconNextFrameButton
			iconImageSize.width: Constants.playbackIconWidth
			iconImageSize.height: Constants.playbackIconHeight

			borderRadius: 0

			onClicked: goToNextFrame()
		}

		TimelineButton {
			id: lastFrameButton
			Accessible.name: "Last frame"

			enabled: root.disabled

			Layout.fillHeight: true
			Layout.fillWidth: true
			Layout.minimumWidth: Constants.playbackButtonMinWidth

			iconImage: Constants.iconLastFrameButton
			iconImageSize.width: Constants.playbackIconWidth
			iconImageSize.height: Constants.playbackIconHeight

			borderRadius: 0

			onClicked: goToLastFrame()
		}

		TimelineButton {
			id: stopButton
			Accessible.name: "Stop"

			enabled: root.disabled

			Layout.fillHeight: true
			Layout.fillWidth: true
			Layout.minimumWidth: Constants.playbackButtonMinWidth

			iconImage: Constants.iconStopButton
			iconImageSize.width: Constants.playbackIconWidth
			iconImageSize.height: Constants.playbackIconHeight

			borderRadius: 0

			onClicked: {
				playbackController.state = Sequences.PlaybackController.Paused
				playbackController.sample = 0
				recordButton.stop()
			}
		}

		Connections {
			target: playbackController
			ignoreUnknownSignals: true
			onStateChanged: {
				switch (playbackController.state) {
				case Sequences.PlaybackController.Playing:
					playButton.isPlaying = true
					playButton.iconImage = Constants.iconPauseButton
					recordButton.stop()
					break
				case Sequences.PlaybackController.Paused:
					playButton.isPlaying = false;
					playButton.iconImage = Constants.iconPlayButton
					recordButton.stop()
					break
				case Sequences.PlaybackController.Recording:
					playButton.isPlaying = false;
					playButton.iconImage = Constants.iconPlayButton
					recordButton.start()
					break
				}
			}
		}

		Connections {
			target: context.timelineActionManager
			onTogglePlaybackState: playButton.clicked()
			onToggleRecordState: recordButton.clicked()
			onStopPlayback: stopButton.clicked()
			onScrollToTheBeginning: firstFrameButton.clicked()
			onScrollToTheEnd: lastFrameButton.clicked()
			onPreviousKey: prevFrameButton.clicked()
			onNextKey: nextFrameButton.clicked()
			onZoomOut: sequenceTree.zoomShortcutActivated(-120)
			onZoomIn: sequenceTree.zoomShortcutActivated(120)
		}
	}
}