import QtQuick 2.11

Rectangle {
	id: indicator

	implicitWidth: 2
	implicitHeight: 2

	color: _palette.color2
	visible: control.size < 1.0
	opacity: 0.0

	states: State {
		name: "active"
		when: control.active
		PropertyChanges { target: indicator; opacity: 0.75 }
	}

	transitions: [
		Transition {
			from: "active"
			SequentialAnimation {
				PauseAnimation { duration: 450 }
				NumberAnimation { target: indicator; duration: 200; property: "opacity"; to: 0.0 }
			}
		}
	]
}
