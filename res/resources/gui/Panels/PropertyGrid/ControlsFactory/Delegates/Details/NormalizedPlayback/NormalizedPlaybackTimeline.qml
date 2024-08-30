import QtQuick 2.7

import "../../Settings.js" as Settings
import WGTools.Misc 1.0 as Misc

Rectangle {
	id: timelineFrame

	antialiasing: true
	clip: true

	implicitHeight: Settings.timelineHeight

	color: enabled
		? Settings.timelineBackgroundColor
		: Settings.timelineBackgroundDisabledColor
	radius: Settings.timelineBackgroundRadius

	border.width: enabled ? 0 : 1
	border.color: Settings.timelineStrokeDisabledColor

	Rectangle {
		id: cursor

		height: parent.height
		width: 3

		color: Settings.timelineSliderFocusedBackgroundColor

		anchors.alignWhenCentered: false

		Binding on x {
			value: {
				var clipRatio = delegateRoot.cursorTime / delegateRoot.duration
				var normalizedPos = clipRatio * timelineFrame.width
				return normalizedPos - cursor.width / 2
			}
		}
	}

	Misc.Text {
		anchors.fill: parent
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		color: _palette.color1
		text: delegateRoot.cursorTime.toFixed(1) + " / " + delegateRoot.duration.toFixed(1)
		visible: enabled && delegateRoot.showTimeLabel
	}

	MouseArea {
		id: timelineMA
		property var _isPlaying: false

		anchors.fill: parent

		acceptedButtons: Qt.LeftButton

		onPressed: {
			_isPlaying = delegateRoot.playing

			delegateRoot.playing = false
			timelineMA.updateCursorTime(mouse.x)
		}

		onPositionChanged: {
			var mousePos = mouse.x
			if (mouse.x < 0)
				mousePos = 0
			else if (mouse.x >= timelineMA.width)
				mousePos = timelineMA.width

			timelineMA.updateCursorTime(mousePos)
		}

		onReleased: {
			delegateRoot.playing = _isPlaying
		}

		function updateCursorTime(x) {
			var normClick = x / timelineMA.width

			if (normClick >= 1)
				normClick = 0.999

			delegateRoot.cursorTime = normClick * delegateRoot.duration
		}
	}
}