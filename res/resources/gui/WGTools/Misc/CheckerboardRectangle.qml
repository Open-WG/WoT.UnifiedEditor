import QtQuick 2.7
import QtGraphicalEffects 1.0

Item {
	id: item

	property alias antialiasing: borderRectangle.antialiasing
	property alias radius: borderRectangle.radius
	property alias border: borderRectangle.border

	CheckerboardImage {
		id: img
		width: parent.width
		height: parent.height
		visible: false
	}

	Rectangle {
		id: mask
		antialiasing: parent.antialiasing
		radius: parent.radius
		color: "#FFFFFF"
		visible: false
		anchors.fill: img
	}

	OpacityMask {
		antialiasing: parent.antialiasing
		source: img
		maskSource: mask
		anchors.fill: img
	}

	Rectangle {
		id: borderRectangle
		width: parent.width
		height: parent.height
		color: "transparent"
	}
}
