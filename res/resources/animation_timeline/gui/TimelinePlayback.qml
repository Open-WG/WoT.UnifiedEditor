import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import PlaybackState 1.0

import "Constants.js" as Constants
import "Effects"
import "Buttons"
import "Backgrounds"
import "Debug"

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
		var cursorLocation = playbackController.currentSample

		if (timelineController.isSecondVisible(cursorLocation)) {
			timelineController.focusAroundSecond(0)
			playbackController.currentSample = 0
		}
		else {
			timelineController.focusAroundSecond(cursorLocation)
		}
	}

	function goToLastFrame() {
		var cursorLocation = playbackController.currentSample

		if (timelineController.isSecondVisible(cursorLocation)) {
			timelineController.focusAroundSecond(timelineContext.sequenceDuration)
			playbackController.currentSample = timelineContext.sequenceDuration
		}
		else {
			timelineController.focusAroundSecond(cursorLocation)
		}
	}

	function goToPrevFrame() {
		playbackController.currentSample =
			treeAdapter.getPrevKeySample(playbackController.currentSample)
		timelineController.focusAroundSecond(playbackController.currentSample)
	}

	function goToNextFrame() {
		playbackController.currentSample =
			treeAdapter.getNextKeySample(playbackController.currentSample)
		timelineController.focusAroundSecond(playbackController.currentSample)
	}

	RowLayout {
		id: row
		spacing: 0
		anchors.fill: parent
		//anchors.rightMargin: -1

		Button {
			id: recordButton

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
				playbackController.record()
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

			enabled: root.disabled

			property bool isPlaying: false

			Layout.fillHeight: true
			Layout.fillWidth: true
			Layout.minimumWidth: Constants.playbackButtonMinWidth

			iconImage: Constants.iconPlayButton
			iconImageSize.width: Constants.playbackIconWidth
			iconImageSize.height: Constants.playbackIconHeight

			borderRadius: 0

			onClicked: {
				if (!isPlaying) {
					playbackController.play()
					isPlaying = true
					iconImage = Constants.iconPauseButton
				}
				else {
					playbackController.pause()
					isPlaying = false
					iconImage = Constants.iconPlayButton
				}
			}
		}

		TimelineButton {
			id: nextFrameButton

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

			enabled: root.disabled

			Layout.fillHeight: true
			Layout.fillWidth: true
			Layout.minimumWidth: Constants.playbackButtonMinWidth

			iconImage: Constants.iconStopButton
			iconImageSize.width: Constants.playbackIconWidth
			iconImageSize.height: Constants.playbackIconHeight

			borderRadius: 0

			onClicked: {
				playbackController.stop()
				recordButton.stop()
			}
		}

		Connections {
			target: playbackController
			ignoreUnknownSignals: true
			onPlaybackStateChanged: {
				switch (playbackController.state) {
				case PlaybackState.Playing:
					playButton.isPlaying = true
					playButton.iconImage = Constants.iconPauseButton
					recordButton.stop()
					break
				case PlaybackState.Paused:
					playButton.isPlaying = false;
					playButton.iconImage = Constants.iconPlayButton
					recordButton.stop()
					break
				case PlaybackState.Recording:
					playButton.isPlaying = false;
					playButton.iconImage = Constants.iconPlayButton
					recordButton.start()
					break
				}
			}
		}
	}
}