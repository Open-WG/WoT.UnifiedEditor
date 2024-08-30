import QtQuick 2.11

DropArea {
	id: da
	anchors.right: parent.right
	anchors.left: parent.left
	anchors.top: topSide ? parent.top : undefined
	anchors.bottom: topSide ? undefined : parent.bottom
	height: parent.height / 2

	property var index: styleData.index
	property bool topSide: true
	property bool selectionDroppable: false

	onDropped: {
		if (selectionDroppable)
			styleData.context.moveSelectedItems(index, topSide)
	}

	onEntered: {
		selectionDroppable = styleData.context.isSelectionDroppable(index);

		if (!selectionDroppable)
			styleData.context.setForbiddenCursor();
	}

	onExited: styleData.context.resetCursor();

	Rectangle {
		color: "white"
		visible: parent.visible && da.containsDrag && da.selectionDroppable
		anchors.right: parent.right
		anchors.left: parent.left
		anchors.top: parent.topSide ? parent.top : undefined
		anchors.bottom: parent.topSide ? undefined : parent.bottom
		height: 3
	}
}