import QtQuick 2.11
import QtQml.Models 2.11

Column {
	id: view

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
				selectionModel: view.selectionModel
				sourceModelAdapter: view.sourceModelAdapter
				thisDelegateModel: delegateModel
			}
		}
	}
}
