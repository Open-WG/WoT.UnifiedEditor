import QtQml 2.2
import QtQuick 2.7

import "Constants.js" as Constants
import PlaybackState 1.0

Item {
	id: cursor

	property var timelineController : null
	property var playbackController : null
	property var context : null

	anchors.bottom : parent.bottom
	
	function getPosition() {
		return Math.round(timelineController.fromScaleToScreen(playbackController.currentSample * 60))
	}

	x: getPosition()
	anchors.alignWhenCentered: false

	Image {
		id: cursorImage

		source: Constants.imageCursor

		anchors.horizontalCenter : parent.horizontalCenter
		anchors.bottom: parent.bottom
		anchors.alignWhenCentered: true
		sourceSize.width: Constants.cursorWidth
		sourceSize.height: Constants.cursorHeight
	}

	Connections {
		target: timelineController
		ignoreUnknownSignals: true
		onScaleChanged: cursor.x = Qt.binding(getPosition)
	}

	Connections {
		target: playbackController
		ignoreUnknownSignals: true

		onCurrentSampleChanged: {
			cursor.x = Qt.binding(getPosition)
		}

		onPlaybackStateChanged: {
			if (playbackController.state != PlaybackState.Recording && 
				playbackController.currentSample > context.sequenceDuration) {
				playbackController.currentSample = context.sequenceDuration
			}
		}
	}

	Connections {
		target: context
		ignoreUnknownSignals: true

		onSequenceDurationChanged: {
			if (playbackController.state != PlaybackState.Recording && 
				playbackController.currentSample > context.sequenceDuration) {
				playbackController.currentSample = context.sequenceDuration
			}
		}
	}
}