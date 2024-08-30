import QtQuick 2.7

MouseArea {
	property bool needCommit: false;
	property real handlePosX

	signal modified(bool commit, int modifiers)

	width: control.width
	height: control.height
	visible: control.hovered
	cursorShape: Qt.SizeHorCursor

	onReleased: {
		control.modified(true, 0)
	}

	onPositionChanged: {
		if (pressed)
		{
			var dx = mouse.x - handlePosX
			var newValue = boundValue(control.value + (dx / width) * control.fullRange)

			if (newValue != control.value) {
				control.value = newValue
				modified(false, mouse.modifiers)

				needCommit = true
			}
		}
	}

	function boundValue(value) {
		if (value < control.from) {
			value = control.from
		}

		if (value > control.to) {
			value = control.to
		}

		return value
	}
}
