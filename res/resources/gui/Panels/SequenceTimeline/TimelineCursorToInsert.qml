import QtQml 2.2
import QtQuick 2.7

import "Constants.js" as Constants

Rectangle {
	id: insertCursor

	property var timelineController : null
	property var playbackController : null
	property var mouseCursorPosX : null

	function getPosition() {
		return mouseCursorPosX //Math.round(timelineController.fromValueToPixels(mouseCursorPosX)) + 2
	}

	x: getPosition()
	anchors.alignWhenCentered: true

	width: 1
	color: "white"

	Binding on x { value: getPosition() }
	
	Connections {
		target: timelineController
		ignoreUnknownSignals: false
		onScaleChanged: insertCursor.x = getPosition()
	}
}
