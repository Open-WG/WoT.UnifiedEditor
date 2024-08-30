import QtQuick 2.11
import WGTools.AnimSequences 1.0 as AS
import WGTools.DataModel.Utils 1.0 as DMUtils

Loader {
	id: loader

	property alias sourceModelAdapter: indexProvider.adaptorModel
	property alias selectionModel: indexProvider.selectionModel
	property Item foreground

	readonly property QtObject styleData: QtObject {
		readonly property var data: dataProvider.data

		readonly property alias modelAdapter: loader.sourceModelAdapter
		readonly property alias modelIndex: indexProvider.index

		readonly property alias selectionModel: loader.selectionModel
		readonly property alias timelineViewID: loader.foreground
	}

	source: "CurveView.qml"
	active: visible
	enabled: visible

	Accessible.name: "Curve Editor"

	function select(selectionFrame, selectionHelper) {
		if (status == Loader.Ready)
			item.selectKeys(selectionFrame, selectionHelper)
	}

	AS.CurveEditorIndexProvider {
		id: indexProvider
	}

	DMUtils.ModelDataProxy {
		id: dataProvider
		model: indexProvider.adaptorModel
		index: indexProvider.index
		role: "itemData"
	}
}
