import QtQuick 2.7

Transition {
	id: transition

	property real duration: 100

	NumberAnimation {
		target: control
		property: "opacity"
		duration: transition.duration
		easing.type: Easing.InOutQuad

		from: 0
		to: 1
	}

	NumberAnimation {
		target: control
		property: "scale"
		duration: transition.duration
		easing.type: Easing.InOutQuad

		from: 0.7
		to: 1
	}
}
