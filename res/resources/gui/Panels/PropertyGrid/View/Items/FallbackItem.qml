import QtQuick 2.10

Rectangle {
	height: 30
	color: "red"

	border {
		width: 1
		color: "black"
	}

	Text {
		text: styleData.holder.getType() + " at depth: " + (styleData.group.depth + 1)
		anchors.centerIn: parent
	}
}
