import QtQuick 2.10

Item {
	id: edgeDelegateItem

	width: edgeLoader.width
	height: edgeLoader.height
	
	readonly property int itemIndex: index
	readonly property var itemModel: model

	Loader {
		id: edgeLoader

		sourceComponent: edgeDelegate

		readonly property alias index: edgeDelegateItem.itemIndex
		readonly property alias model: edgeDelegateItem.itemModel

		property QtObject styleData: QtObject {
			readonly property var selfModelIndex: delegateModel.modelIndex(index)
			readonly property var selectionModel: root.selectionModel
		}
	}
}
