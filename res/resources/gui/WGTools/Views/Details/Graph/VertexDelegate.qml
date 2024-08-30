import QtQuick 2.10

Item {
	id: vertexDelegateItem

	width: vertexLoader.width
	height: vertexLoader.height
	
	readonly property int itemIndex: index
	readonly property var itemModel: model

	Loader {
		id: vertexLoader
		sourceComponent: vertexDelegate

		readonly property alias index: vertexDelegateItem.itemIndex
		readonly property alias model: vertexDelegateItem.itemModel

		property QtObject styleData: QtObject {
			readonly property var selfModelIndex: delegateModel.modelIndex(index)
			readonly property var selectionModel: root.selectionModel
			readonly property var edgeRequestor: root.edgeRequestor
		}

		Connections {
			target: vertexLoader.item
			ignoreUnknownSignals: false

			onEdgeCreationStarted: {
				if (edgeRequestor) {
					stubEdge.fromVertexIndex = delegateModel.modelIndex(index)
					stubEdge.visible = true
					stubEdge.styleData.fromX = itemData.centerX
					stubEdge.styleData.fromY = itemData.centerY
					stubEdge.styleData.toX = itemData.centerX
					stubEdge.styleData.toY = itemData.centerY
				}
			}

			onLeftClicked: {
				if (stubEdge.visible) {
					stubEdge.visible = false
					edgeRequestor.requestEdgeCreation(
						graphModel.getVertex(stubEdge.fromVertexIndex),
						graphModel.getVertex(delegateModel.modelIndex(index)))
				}
			}
		}
	}
}