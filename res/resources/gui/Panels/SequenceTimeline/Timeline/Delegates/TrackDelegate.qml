import QtQuick 2.11
import WGTools.AnimSequences 1.0
import Panels.SequenceTimeline.Menus 1.0

Loader {
	id: timeLineTrackLoader

	property QtObject styleData: QtObject {
		readonly property var model: index != -1 ? sourceModelAdapter : null
		readonly property var modelIndex: index != -1 ? thisDelegateModel.modelIndex(index) : null
		readonly property var context: rootSequenceTree.rootContext

		readonly property var selectionModel: rootSequenceTree.selectionModel
		readonly property var timelineController: context.timelineController
		readonly property var keyMoveSignalHolder: rootSequenceTree
		readonly property var timelineViewID: rootSequenceTree.timelineViewID

		readonly property var keyType: itemData.keyType
	}

	width: parent.width
	source: switch (itemData.keyType) {
		case SequenceItemTypes.SimpleKey:
		case SequenceItemTypes.CurveKey:
			return "Keys/SimpleKeyItem.qml"
		case SequenceItemTypes.ContainerKey:
			return "Keys/ContainerKeyItem.qml"
		default:
			return ""
	}

	Accessible.name: "Track"

	ContextMenuTrack {
		id: trackPopupMenu
		visible: false

		onAddKeyPressed: {
			var frame = context.timelineController.fromScreenToScaleClipped(trackPopupMenu.x)
			var seconds = context.timelineController.fromFramesToSeconds(frame)
			model.itemData.insertKeyAt(seconds)
		}
	}

	MouseArea {
		id: maKeyPlacer

		propagateComposedEvents: true
		acceptedButtons: Qt.LeftButton | Qt.RightButton

		anchors.fill: parent

		onPressed: {
			if (mouse.button == Qt.RightButton) {
				var point = mapToItem(timeLineTrackLoader, mouse.x, mouse.y)
				trackPopupMenu.x = point.x
				trackPopupMenu.y = point.y
				trackPopupMenu.open()
			}

			mouse.accepted = false
		}

		onDoubleClicked: {
			if (containsMouse) {
				var frame = context.timelineController.fromScreenToScaleClipped(mouseX)
				var seconds = context.timelineController.fromFramesToSeconds(frame)

				model.itemData.insertKeyAt(seconds)
			}
		}
	}
}
