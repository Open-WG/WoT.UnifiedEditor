import QtQuick 2.7

Item {
	id: root

	property bool isRunning: false
	property var target : null
	property real from: 0
	property real to: 0
	property var properties: null
	property real upDuration: 0
	property real downDuration: 0

	SequentialAnimation {
		id: sequence

		//running: root.isRunning

		loops: Animation.Infinite

		NumberAnimation {
			target: root.target
			properties: root.properties
			from: root.from
			to: root.to
			duration: root.upDuration
		}

		NumberAnimation {
			target: root.target
			properties: root.properties
			from: root.to
			to: root.from
			duration: root.downDuration
		}
	}

	function stop() {
		sequence.stop()
	}

	function start() {
		sequence.start()
	}
}