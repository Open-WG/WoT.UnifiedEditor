import QtQuick 2.11

Rectangle {
	id: item

	property var modelIndex: null
	property var selectionModel: null
	property int _selectionFlag: 0 // 0 - unselected; 1 - selected; 2 - parent selected

	color: _palette.color12
	opacity: _selectionFlag == 2 ? 0.3 : 0.7
	visible: _selectionFlag > 0

	function getSelectionFlag() {
		if (selectionModel == null)
			return 0

		if (selectionModel.isSelected(modelIndex))
			return 1

		if (selectionModel.isSelected(modelIndex.parent))
			return 2
		
		return 0
	}

	Binding on _selectionFlag { value: getSelectionFlag() }
	Connections {
		target: item.selectionModel
		ignoreUnknownSignals: false
		onSelectionChanged: item._selectionFlag = item.getSelectionFlag()
	}
}
