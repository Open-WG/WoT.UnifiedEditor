import QtQuick 2.11
import QtQml.Models 2.11

Item {
	id: monitor

	property var modelIndex: null
	property ItemSelectionModel selectionModel: null

	property bool _selected: false
	readonly property alias selected: monitor._selected

	function getSelected() {
		return selectionModel && selectionModel.isSelected(modelIndex)
	}

	Binding on _selected { value: getSelected() }
	Connections {
		target: monitor.selectionModel
		ignoreUnknownSignals: false
		onSelectionChanged: monitor._selected = monitor.getSelected()
	}
}
