import QtQuick 2.11
import QtQml.Models 2.11
import WGTools.PropertyGrid 1.0
import Panels.PropertyGrid.View 1.0

PropertyGrid {
	property alias source: pgModel.source
	property alias assetSelection: selectionAdapter.assetSelection
	property alias changesController: pgModel.changesController

	model: PropertyGridModel {
		id: pgModel
		source: null // Default binding, which will be restored in case of deactivation of the assigned bindings
	}

	selection: ItemSelectionModel {
		id: pgSelectionModel
		model: pgModel
	}

	PropertySelectionAdapter {
		id: selectionAdapter
		selectionModel: pgSelectionModel
	}
}
