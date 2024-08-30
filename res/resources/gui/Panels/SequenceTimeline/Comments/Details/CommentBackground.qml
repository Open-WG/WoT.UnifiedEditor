import QtQuick 2.11

Rectangle {
	implicitHeight: 18
	color: "white"
	opacity: 0.2
	radius: 3

	layer.enabled: true

	Rectangle {
		width: parent.width
		height: parent.radius
		color: parent.color
	}
}
