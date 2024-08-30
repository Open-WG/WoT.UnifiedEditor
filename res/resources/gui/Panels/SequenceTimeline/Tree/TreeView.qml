import QtQuick 2.11
import QtQml.Models 2.11

Item {
	id: treeViewRoot
		
	property int highlightIndex: -1
	property bool topSide: true

	property alias sourceModelAdapter: view.sourceModelAdapter
	property alias selectionModel: view.selectionModel
	property alias repeater: view.repeater

	implicitHeight: view.implicitHeight
	implicitWidth: view.implicitWidth

	Column {
		id: view

		height: treeViewRoot.height
		width: treeViewRoot.width

		property var sourceModelAdapter: null
		property ItemSelectionModel selectionModel: null
		property alias repeater: repeater

		spacing: 0
		clip: true

		Repeater {
			id: repeater

			model: DelegateModel {
				id: delegateModel
				model: view.sourceModelAdapter

				delegate: TreeDelegate {
					width: parent.width
					selectionModel: treeViewRoot.selectionModel
					sourceModelAdapter: treeViewRoot.sourceModelAdapter
					thisDelegateModel: delegateModel
					z: repeater.count - index
				}
			}
		}
	}

	Rectangle {
		id: indicator
		color: "white"
		height: 3
		width: parent.width
		visible: highlightIndex != -1

		onVisibleChanged: {
			if(visible) {
				if(topSide) {
					var thisItem = repeater.itemAt(highlightIndex)
					indicator.y = thisItem.y
				} else {
					var sourceIndex = treeViewRoot.sourceModelAdapter.mapToModel(delegateModel.modelIndex(highlightIndex))
					var childrenCount = rootSequenceTree.getVisibleChildrenCount(sourceIndex)
					var lastChildItem = repeater.itemAt(highlightIndex + childrenCount)
					indicator.y = lastChildItem.y + lastChildItem.height - indicator.height
				}
			} 
		}
	}
}