import QtQuick 2.11
import QtQml.Models 2.11

Column {
	id: view

	property var sourceModelAdapter: null
	property ItemSelectionModel selectionModel: null

	spacing: 0

	function select(selectionFrame, selectionHelper) {
		for (var i = 0; i < repeater.count; ++i)
			repeater.itemAt(i).select(selectionFrame, selectionHelper)
	}

	Repeater {
		id: repeater
		model: DelegateModel {
			id: delegateModel
			model: view.sourceModelAdapter

			delegate: TimelineDelegate {
				width: parent.width
				selectionModel: view.selectionModel
				sourceModelAdapter: view.sourceModelAdapter
				thisDelegateModel: delegateModel
			}
		}
	}
}
