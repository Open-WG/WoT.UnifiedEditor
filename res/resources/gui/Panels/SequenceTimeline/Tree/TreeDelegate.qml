import QtQuick 2.11
import Panels.SequenceTimeline.CurveEditor 1.0

Column {
	id: item

	property var sourceModelAdapter: null
	property var thisDelegateModel: null
	property alias selectionModel: selection.selectionModel

	onHeightChanged: {
		rootSequenceTree.updateHeihgts()
	}

	TreeItemLoader {
		id: treeItemLoader
		width: parent.width

		property QtObject styleData: QtObject {
			readonly property var view: rootSequenceTree
			readonly property var index: selection.modelIndex
			readonly property var selectionModel: selection.selectionModel
			readonly property bool expanded: isExpanded
			readonly property var context: rootSequenceTree.rootContext
			property var addTrackSignHolder: treeItemLoader
			property var curveEditorEnabled: false
		}

		SelectionMonitor {
			id: selection
			modelIndex: item.sourceModelAdapter.mapToModel(item.thisDelegateModel.modelIndex(index))
		}
	}

	CurvePropertiesLoader {
		width: parent.width
		visible: treeItemLoader.styleData.curveEditorEnabled
	}
}
