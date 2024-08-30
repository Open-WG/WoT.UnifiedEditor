import QtQuick 2.11

Item {
	id: item

	property var sourceModelAdapter: null
	property var thisDelegateModel: null
	property alias selectionModel: row.selectionModel

	implicitWidth: timelineItemLoader.implicitWidth
	implicitHeight: timelineItemLoader.implicitHeight

	Connections {
		target: rootSequenceTree
		onUpdateHeihgts: {
			var treeItem = treeView.repeater.itemAt(index)
			item.height = treeItem ? treeItem.implicitHeight : implicitHeight
		}
	}

	function select(box, selection) {
		if (timelineItemLoader.item && timelineItemLoader.item.item) {
			timelineItemLoader.item.item.selectKeys(box, selection)
		}
	}

	TimelineRow {
		id: row
		width: parent.width
		height: parent.height
		modelIndex: item.sourceModelAdapter ? item.sourceModelAdapter.mapToModel(item.thisDelegateModel.modelIndex(index)) : null
	}

	TimelineItemLoader {
		id: timelineItemLoader
		width: parent.width
	}
}
