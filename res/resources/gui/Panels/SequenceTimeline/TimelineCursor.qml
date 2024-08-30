import QtQml 2.2
import QtQuick 2.7

import "Constants.js" as Constants
import WGTools.AnimSequences 1.0 as Sequences

Item {
	id: cursor

	property var timelineController : null
	property var playbackController : null

	anchors.bottom : parent.bottom
	
	function getPosition() {
		if (playbackController)
			return Math.round(timelineController.fromValueToPixels(playbackController.sample * 60))
		return 0
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

		onSampleChanged: {
			cursor.x = Qt.binding(getPosition)
		}

		onPlaybackStateChanged: {
			if (playbackController.state != PlaybackState.Recording && 
				playbackController.sample > context.sequenceDuration) {
				playbackController.sample = context.sequenceDuration
			}
		}
	}

	Connections {
		target: context
		ignoreUnknownSignals: true

		onSequenceDurationChanged: {
			if (playbackController.state != PlaybackState.Recording && 
				playbackController.sample > context.sequenceDuration) {
				playbackController.sample = context.sequenceDuration
			}
		}
	}
}