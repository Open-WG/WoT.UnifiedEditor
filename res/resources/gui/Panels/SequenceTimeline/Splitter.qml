import QtQuick 2.11

Rectangle {
	id: splitter

	property real minPosition: 0
	property real maxPosition: 0

	implicitWidth: 1
	color: _palette.color10
	x: minPosition

	MouseArea {
		width: 20
		height: parent.height
		cursorShape: Qt.SizeHorCursor
		hoverEnabled: true
		preventStealing: true

		anchors.horizontalCenter: parent.horizontalCenter
		drag {
			target: splitter
			axis: Drag.XAxis
			minimumX: splitter.minPosition
			maximumX: splitter.maxPosition
		}
	}
}
