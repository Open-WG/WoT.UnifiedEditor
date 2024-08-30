import QtQuick 2.11

State {
	PropertyChanges {
		target: root
		implicitWidth: marker.implicitWidth
		implicitHeight: marker.implicitHeight
	}

	PropertyChanges {
		target: background
		width: 0
		opacity: 0
		visible: false
	}

	PropertyChanges {
		target: label
		opacity: 0
		visible: false
		x: 0
	}

	PropertyChanges {
		target: durationLine
		width: 0
		visible: false
	}
}
