import QtQuick 2.7
import QtQml 2.2
import WGTools.Templates 1.0

MouseArea {
	id: controller

	signal firstModified(bool commit)
	signal secondModified(bool commit)

	acceptedButtons: Qt.NoButton
	enabled: parent //&& parent.wheelEnabled
	z: -1

	anchors.fill: parent

	Keys.onPressed: p.processKeyEvent(event, true)
	Keys.onReleased: p.processKeyEvent(event, false)
	Component.onCompleted: p.setupKeyInput()

	// onWheel: p.processWheel(wheel)

	Connections {
		target: p
		onControlChanged: p.setupKeyInput()
	}

	Connections {
		target: p.control
		onActiveFocusChanged: p.processActiveFocus()
	}

	Connections {
		target: p.control ? p.control.first : null
		onMoved: p.notifyFirst()
		onPressedChanged: p.processButtonPressed(p.control.first)
	}

	Connections {
		target: p.control ? p.control.second : null
		onMoved: p.notifySecond()
		onPressedChanged: p.processButtonPressed(p.control.second)
	}

	// Timer {
	// 	id: wheelTimer
	// 	interval: 3000
	// 	onTriggered: p.stopTimer()
	// }

	QtObject {
		id: p

		readonly property RangeSlider control: controller.parent
		readonly property bool istransient: control && (keyPressed || buttonPressed /*|| wheelAccrued*/)

		property bool keyPressed: false
		property bool buttonPressed: false
		// property bool wheelAccrued: false
		property bool needCommitFirst: false
		property bool needCommitSecond: false

		onIstransientChanged: {
			if (istransient)
				return

			if (needCommitFirst)
				notifyFirst()

			if (needCommitSecond)
				notifySecond()
		}

		// function startTimer() {
		// 	wheelAccrued = true
		// 	wheelTimer.restart()
		// }

		// function stopTimer() {
		// 	wheelTimer.stop()
		// 	wheelAccrued = false
		// }

		function setupKeyInput() {
			if (control != null) {
				control.Keys.forwardTo = controller
			}
		}

		function processActiveFocus() {
			if (control.activeFocus)
				return

			// stopTimer()
		}

		function processKeyEvent(event, pressed) {
			if (event.isAutoRepeat)
				return

			if (event.key == Qt.Key_Left ||
				event.key == Qt.Key_Right)
			{
				// stopTimer()
				keyPressed = pressed
			}

			event.accepted = false
		}

		function processButtonPressed(sender) {
			// stopTimer()
			buttonPressed = sender.pressed
		}

		function notifyFirst() {
			controller.firstModified(!istransient)
			needCommitFirst = istransient
		}

		function notifySecond() {
			controller.secondModified(!istransient)
			needCommitSecond = istransient
		}
	}
}
