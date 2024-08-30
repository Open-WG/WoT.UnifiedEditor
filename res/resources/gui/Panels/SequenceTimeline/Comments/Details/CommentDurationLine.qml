import QtQuick 2.11

Rectangle {
	id: line

	property alias hovered: hoveredState.when

	implicitHeight: 1
	width: implicitWidth
	height: implicitHeight
	color: "#E0E0E0"
	opacity: 0.2

	states: State {
		id: hoveredState
		name: "hovered"

		PropertyChanges {
			target: line
			color: Qt.lighter(_palette.color12, 1.4)
			opacity: 1
		}
	}

	transitions: Transition {
		ParallelAnimation {
			ColorAnimation { target: line; duration: 500 }
			NumberAnimation { target: line; property: "opacity"; duration: 500; }
		}
	}
}
