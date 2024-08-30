import QtQuick 2.7

Item {
	property color color: _palette.color2
	property real thickness: 0

	property alias leftVisible: leftBorder.visible
	property alias rightVisible: rightBorder.visible
	property alias topVisible: topBorder.visible
	property alias bottomVisible: bottomBorder.visible

	Rectangle {
		id: leftBorder
		width: parent.thickness
		height: parent.height
		color: parent.color
		anchors.left: parent.left
	}

	Rectangle {
		id: rightBorder
		width: parent.thickness
		height: parent.height
		color: parent.color
		anchors.right: parent.right
	}

	Rectangle {
		id: topBorder
		width: parent.width
		height: parent.thickness
		color: parent.color
		anchors.top: parent.top
	}

	Rectangle {
		id: bottomBorder
		width: parent.width
		height: parent.thickness
		color: parent.color
		anchors.bottom: parent.bottom
	}
}
