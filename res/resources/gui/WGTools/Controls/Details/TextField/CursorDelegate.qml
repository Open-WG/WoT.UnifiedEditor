import QtQuick 2.11

Rectangle {
	id: cursorDelegate

	property Item textInput

	width: textInput.cursorRectangle.width
	height: textInput.cursorRectangle.height
	visible: textInput.activeFocus
	color: _palette.color1
	antialiasing: false
	state: "on"

	Connections {
		target: textInput
		onCursorPositionChanged: {
			state = "on"
			timer.restart()
		}
	}

	Timer {
		id: timer
		running: cursorDelegate.visible
		repeat: true
		interval: Qt.styleHints.cursorFlashTime / 2
		onTriggered: cursorDelegate.state = cursorDelegate.state == "on" ? "off" : "on"
	}

	states: [
		State {
			name: "on"
			PropertyChanges { target: cursorDelegate; opacity: 1 }
		},
		State {
			name: "off"
			PropertyChanges { target: cursorDelegate; opacity: 0 }
		}
	]

	transitions: [
		Transition {
			from: "on"
			to: "off"
			NumberAnimation { property: "opacity"; duration: 50 }
		}
	]
}
