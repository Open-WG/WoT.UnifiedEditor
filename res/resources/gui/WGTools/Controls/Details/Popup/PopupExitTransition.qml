import QtQuick 2.7

Transition {
	id: transition

	property real duration: 100

	NumberAnimation {
		target: control
		property: "opacity"
		duration: transition.duration
		easing.type: Easing.InOutQuad

		from: 1
		to: 0
	}

	NumberAnimation {
		target: control
		property: "scale"
		duration: transition.duration
		easing.type: Easing.InOutQuad

		from: 1
		to: 0.9
	}
}
