import QtQuick 2.7
import QtQml.Models 2.2

Item {
	id: root

	x: loader.x
	y: loader.y
	width: loader.width
	height: loader.height

	property var _model: model ? model : null
	property var _selectionModel : styleData.selectionModel
	property var selfModelIndex: styleData ? styleData.selfModelIndex : null

	readonly property var fromVertex: model ? model.itemData.fromVertex : null
	readonly property var toVertex: model ? model.itemData.toVertex : null

	Loader {
		id: loader

		readonly property alias index: root.selfModelIndex
		readonly property alias model: root._model 

		property QtObject styleData: QtObject {
			property var fromX: model && root.fromVertex ? root.fromVertex.centerX : 0
			property var fromY: model && root.fromVertex? root.fromVertex.centerY : 0
			property var toX: model && root.toVertex ? root.toVertex.centerX : 0
			property var toY: model && root.toVertex ? root.toVertex.centerY : 0
			property var vertexWidth: root.fromVertex ? root.fromVertex.width : 0
			property var vertexHeight: root.fromVertex ? root.fromVertex.height : 0
			property var selectionModel: root._selectionModel
		}

		source: _model
			? (fromVertex != toVertex ? "details/TwoVertexEdge.qml" : "details/SameVertexEdge.qml")
			: ""
	}
}
