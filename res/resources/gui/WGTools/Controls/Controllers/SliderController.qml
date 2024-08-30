import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Templates 2.2 as T
import QtQml 2.2

MouseArea {
	id: controller

	property var decimals: 2
	property var step: 0
	property var stepMultiplier: 1

	signal modified(bool commit)

	acceptedButtons: Qt.NoButton
	enabled: parent && parent.wheelEnabled
	z: -1
	anchors.fill: parent

	onWheel: p.processWheel(wheel)
	Keys.onPressed: p.processKeyEvent(event, true)
	Keys.onReleased: p.processKeyEvent(event, false)

	Connections {
		target: p.control
		ignoreUnknownSignals: true
		onMoved: p.notify()
		onPressedChanged: p.processButtonPressed()
		onActiveFocusChanged: p.processActiveFocus()
	}

	// Row {
	// 	spacing: 5
	// 	anchors.bottom: parent.top
	// 	Repeater {
	// 		model: [p.istransient, p.buttonPressed, p.keyPressed, p.wheelAccrued, p.needCommit]
	// 		Rectangle {width: 10; height: 10; color: modelData ? "red" : "green"}
	// 	}
	// }

	Timer {
		id: wheelTimer
		interval: 3000
		onTriggered: p.stopTimer()
	}

	QtObject {
		id: p

		readonly property T.Slider control: controller.parent
		readonly property bool istransient: control && (buttonPressed || keyPressed || wheelAccrued)

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

		function processButtonPressed() {
			stopTimer()
			buttonPressed = control.pressed
		}

		function processKeyEvent(event, pressed) {
			if (event.isAutoRepeat)
				return

			if (event.key == Qt.Key_Left ||
				event.key == Qt.Key_Right) {
				stopTimer()
				keyPressed = pressed
			} else if (event.modifiers & Qt.ControlModifier) {
				if (event.modifiers & Qt.ShiftModifier) {
					if(decimals == 0 && Math.round(step)%100 == 0 || decimals != 0){
						stepMultiplier = 0.01
					}
					else{
						stepMultiplier = 0.0
					}
				} else {
					if(decimals == 0 && Math.round(step)%10 == 0 || decimals != 0){
						stepMultiplier = 0.1
					}
					else{
						stepMultiplier = 0.0
					}
				}
			} else if (event.modifiers & Qt.AltModifier) {
				if (event.modifiers & Qt.ShiftModifier) {
					stepMultiplier = 100
				} else {
					stepMultiplier = 10
				}
			} else {
				stepMultiplier = 1
			}

			event.accepted = false
		}

		function processWheel(wheel) {
			startTimer()
			wheel.accepted = false
		}

		function processActiveFocus() {
			if (!control.activeFocus)
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
