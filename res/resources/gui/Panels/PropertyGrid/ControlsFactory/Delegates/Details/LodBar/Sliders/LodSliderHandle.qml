import QtQuick 2.7

MouseArea {
	width: 10
	height: control.height
	x: (control.fullRange ? (control.width * (control.value / control.fullRange)) : 0) - (width / 2)
	
	acceptedButtons: Qt.NoButton
	cursorShape: Qt.SizeHorCursor
	hoverEnabled: true

	HandleIndicator {
		x: (parent.width - width) / 2
		y: (parent.height - height) / 2
		active: control.pressed || control.hovered
	}
}
