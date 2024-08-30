import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQml 2.2
import QtQml.Models 2.2

import QtQuick.Controls 1.4
import QtQuick.Window 2.2

import WGTools.Controls 2.0
import WGTools.AnimSequences 1.0 as Sequences

import "../../SequenceTimeline/Helpers.js" as Helpers
import "../../SequenceTimeline/Constants.js" as Constants
import "../../SequenceTimeline"
import "../../SequenceTimeline/Effects"
import "../../SequenceTimeline/Backgrounds"
import "../../SequenceTimeline/Buttons"

Item {
	id: root

	readonly property alias minWidth: row.implicitWidth

	property var playbackController : null
	property var timelineController : null
	property var treeAdapter: null
	property bool disabled: false

	implicitHeight: Constants.timelineScaleHeight
	clip: true

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

	function focusAroundFrames() {
		var startSecond = context.calculateFirstFrameTime();
		var endSecond = context.sequenceModel.sequenceDuration;
		var startFrame = timelineController.fromSecondsToFrames(startSecond);
		var endFrame = timelineController.fromSecondsToFrames(endSecond);
		var spaceSize = (endFrame - startFrame) * 0.05;
		startFrame -= spaceSize;
		endFrame += spaceSize;
		if (startFrame != endFrame)
		{
			timelineController.focusAroundRange(startFrame, endFrame)
		}
	}

	function focusAroundCursor(scale) {
		var cursorLocation = playbackController.sample
		var startSecond = cursorLocation - (scale / 2)
		var endSecond = cursorLocation + (scale / 2)
		var startFrame = timelineController.fromSecondsToFrames(startSecond)
		var endFrame = timelineController.fromSecondsToFrames(endSecond)
		timelineController.focusAroundRange(startFrame, endFrame)
	}

	function switchZoom(scale){
		if (isFinite(scale))
		{
			focusAroundCursor(scale);
		}
		else
		{
			focusAroundFrames()
		}
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
				rootContext.record = !rootContext.record
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
				playbackController.state = Sequences.PlaybackController.Paused
				playbackController.sample = 0
				rootContext.record = false
			}
		}

		Connections {
			target: rootContext
			ignoreUnknownSignals: true
			onRecordChanged: {
				if (!rootContext.record)
				{
					recordButton.stop()
				}
				else
				{
					recordButton.start()
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
			onZoomSwitch: switchZoom(scale)
		}
	}
}
