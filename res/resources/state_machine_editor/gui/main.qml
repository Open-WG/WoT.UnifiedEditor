import QtQuick 2.7
import QtQml.Models 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "Graph"
import "Parameters"

Item {
	id: root
	property alias mainWindow: root
	
	SplitView {
		anchors.fill: parent
		orientation: Qt.Horizontal

		handleDelegate: Rectangle {
			color: "black"
			width: 1
		}

		SMMenuControl {
			z: graphView.z + 1

			implicitWidth: 300

			Layout.minimumWidth: 300

			Layout.fillHeight: true
		}

		GraphView {
			id: graphView

			Layout.minimumWidth: 300
			Layout.fillWidth: true
			Layout.fillHeight: true

			graphModel: smeContext.graphModel
			selectionModel: smeContext.selectionModel
			vertexRequestor: smeContext.vertexCreationRequestor
			edgeRequestor: smeContext.edgeCreationRequestor
			controller: smeContext.controller
			
			edgeDelegate: Edge {
			}

			vertexDelegate: Vertex {
				color: model && model.itemData.isStartingNode ? "#f99000" : "#1a1a1a"
				textColor: model && model.itemData.isStartingNode ? "black" : "white"
			}

			onRemoveItems: {
				if (selection.length) {
					smeContext.removeSelection(selection)
				}
			}

			StartingControl {
				visible: smeContext.graphModel.isEmpty
				vertexRequestor: smeContext.vertexCreationRequestor
			}
		}

		ParametersControl {
			Layout.fillWidth: true
			Layout.fillHeight: true
			Layout.minimumWidth: 200

			controller: smeContext.controller
		}
	}
}
