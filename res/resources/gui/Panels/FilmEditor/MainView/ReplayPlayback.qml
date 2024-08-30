import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQml 2.2
import QtQml.Models 2.2

import QtQuick.Controls 1.4
import QtQuick.Window 2.2

import WGTools.AnimSequences 1.0 as Sequences

import "../../SequenceTimeline/Helpers.js" as Helpers
import "../../SequenceTimeline/Constants.js" as Constants
import "../../SequenceTimeline"
import "../../SequenceTimeline/Buttons"

Item{
	id: root

	property bool disabled: true

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight

	RowLayout {
		id: layout
		spacing: 0

		anchors.fill: parent

		TimelineButton {
			id: nextFrameButton1
			enabled: root.disabled

			Layout.fillHeight: true
			Layout.fillWidth: true
			Layout.minimumWidth: Constants.playbackButtonMinWidth

			iconImage: rootContext.synchronize ? "image://gui/film_editor/lock" : "image://gui/film_editor/unlock"
			iconImageSize.width: Constants.playbackIconWidth
			iconImageSize.height: Constants.playbackIconHeight

			borderRadius: 0

			onClicked: {
				rootContext.synchronize = !rootContext.synchronize
			}
		}

		TimelineButton {
			enabled: root.disabled

			property bool isPlaying: context.playbackController.state == Sequences.PlaybackController.Playing

			Layout.fillHeight: true
			Layout.fillWidth: true
			Layout.minimumWidth: Constants.playbackButtonMinWidth

			iconImage: isPlaying ? Constants.iconPauseButton : Constants.iconPlayButton
			iconImageSize.width: Constants.playbackIconWidth
			iconImageSize.height: Constants.playbackIconHeight

			borderRadius: 0

			onClicked: {
				if (!isPlaying)
					context.playbackController.state = Sequences.PlaybackController.Playing
				else
					context.playbackController.state = Sequences.PlaybackController.Paused
			}
		}

		TimelineButton {
			enabled: root.disabled

			Layout.fillHeight: true
			Layout.fillWidth: true
			Layout.minimumWidth: Constants.playbackButtonMinWidth

			iconImage: Constants.iconStopButton
			iconImageSize.width: Constants.playbackIconWidth
			iconImageSize.height: Constants.playbackIconHeight

			borderRadius: 0

			onClicked: {
				context.playbackController.sample = 0
			}
		}
	}

	Rectangle {
		z: 100
		anchors.fill: parent
		anchors.rightMargin: -1

		color: "transparent"
		border.color: "black"
		border.width: 1
	}
}
