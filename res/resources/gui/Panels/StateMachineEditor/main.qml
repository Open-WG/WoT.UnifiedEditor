import QtQuick 2.11

import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Views 1.0 as Views
import WGTools.Views.Details 1.0 as ViewDetails

ControlsEx.Panel {
	anchors.fill: parent

	layoutHint: "center"

	Views.GraphView {
		id: graphView

		anchors.fill: parent

		graphModel: context.graphModel
		selectionModel: context.selectionModel
		vertexRequestor: context.vertexCreationRequestor
		edgeRequestor: context.edgeCreationRequestor
		controller: context.controller
		
		edgeDelegate: ViewDetails.GraphEdge {
		}

		vertexDelegate: ViewDetails.GraphVertex {
			color: model && model.itemData.isStartingNode ? "#f99000" : "#1a1a1a"
			textColor: model && model.itemData.isStartingNode ? "black" : "white"
		}

		StartingControl {
			visible: context.graphModel.isEmpty
			vertexRequestor: context.vertexCreationRequestor
		}
	}
}