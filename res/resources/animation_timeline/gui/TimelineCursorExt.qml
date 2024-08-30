import QtQml 2.2
import QtQuick 2.7

import "Constants.js" as Constants

Rectangle {
	id: cursor

	property var timelineController : null
	property var playbackController : null

	function getPosition() {
		return Math.round(timelineController.fromSecondstoScale(playbackController.currentSample))
	}

	x: getPosition()
	anchors.alignWhenCentered: true

	width: 1
	color: Constants.playbackCursorColor

	Connections {
		target: timelineController
		ignoreUnknownSignals: false
		onScaleChanged: cursor.x = Qt.binding(getPosition)
	}
}
