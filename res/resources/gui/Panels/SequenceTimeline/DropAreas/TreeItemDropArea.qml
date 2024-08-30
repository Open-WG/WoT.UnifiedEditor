import QtQuick 2.11
import QtQml.Models 2.11

DropArea {
	id: da
	anchors.right: parent.right
	anchors.left: parent.left
	anchors.top: topSide ? parent.top : undefined
	anchors.bottom: topSide ? undefined : parent.bottom
	height: parent.height / 2

	property bool topSide: true
	property bool selectionDroppable: false

	onDropped: {
		if (selectionDroppable) {
			styleData.context.moveSelectedItems(styleData.index, topSide)
			treeViewRoot.highlightIndex = -1
		}
	}

	onEntered: {
		selectionDroppable = styleData.context.isSelectionDroppable(styleData.index)

		if (selectionDroppable) {
			treeViewRoot.topSide = topSide
			treeViewRoot.highlightIndex = index
		} else {
			styleData.context.setForbiddenCursor()
		}
	}

	onExited: {
		styleData.context.resetCursor()
		treeViewRoot.highlightIndex = -1
	}
}