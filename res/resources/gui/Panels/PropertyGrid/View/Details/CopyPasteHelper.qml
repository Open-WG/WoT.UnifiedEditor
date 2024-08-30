import QtQuick 2.10
import WGTools.PropertyGrid 1.0 as WGT

QtObject {
	property alias model: selector.model
	property var selectionModel

	readonly property var __selector: WGT.PropertyGridHelper {
		id: selector
		filterRole: "nodeType"
		filterString: "Property"
		filterSyntax: WGT.PropertyGridHelper.FixedString
	}

	function copy() {
		if (selectionModel && model && model.hasOwnProperty("copy")) {
			let indexes = selector.filterIndexesIncludingChildren(selectionModel.selectedIndexes)
			model.copy(indexes)
			return true
		}

		return false
	}

	function paste() {
		if (selectionModel && model && model.hasOwnProperty("paste")) {
			let indexes = selector.filterIndexesIncludingChildren(selectionModel.selectedIndexes)
			model.paste(indexes)
			return true
		}

		return false
	}
}
