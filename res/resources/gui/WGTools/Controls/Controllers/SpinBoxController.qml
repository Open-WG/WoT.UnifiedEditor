import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQml 2.2

MouseArea {
	id: controller

	property Item control: parent
	signal modified(bool commit)
	signal rollback()

	acceptedButtons: Qt.NoButton
	enabled: parent && parent.wheelEnabled
	z: -1
	anchors.fill: parent

	onWheel: d.processWheel(wheel)
	Keys.onPressed: d.processKeyEvent(event, true)
	Keys.onReleased: d.processKeyEvent(event, false)

	Connections {
		target: controller.control
		ignoreUnknownSignals: true
		onValueModified: d.notify()
		onActiveFocusChanged: d.processActiveFocus()
	}

	Connections {
		target: controller.control.up
		ignoreUnknownSignals: true
		onPressedChanged: d.processButtonPressed(controller.control.up.pressed)
	}

	Connections {
		target: controller.control.down
		ignoreUnknownSignals: true
		onPressedChanged: d.processButtonPressed(controller.control.down.pressed)
	}

	Binding {
		target: controller.control
		property: "dirty"
		value: d.needCommit
	}

	Timer {
		id: wheelTimer
		interval: 3000
		onTriggered: d.stopTimer()
	}

	QtObject {
		id: d

		readonly property bool istransient: controller.control && (buttonPressed || keyPressed || wheelAccrued)
		property bool buttonPressed: false
		property bool keyPressed: false
		property bool wheelAccrued: false
		property bool needCommit: false

		function startTimer() {
			wheelAccrued = true
			wheelTimer.restart()
		}

		function stopTimer() {
			wheelTimer.stop()
			wheelAccrued = false
		}

		function processButtonPressed(pressed) {
			stopTimer()
			buttonPressed = pressed
		}

		function processKeyEvent(event, pressed) {
			if (event.isAutoRepeat)
				return

			if (event.key == Qt.Key_Up ||
				event.key == Qt.Key_Down)
			{
				stopTimer()
				keyPressed = pressed
			}

			if (pressed && (event.key == Qt.Key_Enter ||
							event.key == Qt.Key_Return))
			{
				stopTimer()
			}

			if (pressed && event.key == Qt.Key_Escape)
			{
				controller.rollback()
				needCommit = false
				
				stopTimer()
			}

			event.accepted = false
		}

		function processWheel(wheel) {
			startTimer()
			wheel.accepted = false
		}

		function processActiveFocus() {
			if (!controller.control.activeFocus)
			{
				stopTimer()
			}
		}

		function notify() {
			controller.modified(!istransient)
			needCommit = istransient
		}

		onIstransientChanged: {
			if (!istransient && needCommit)
			{
				notify()
			}
		}
	}
}
