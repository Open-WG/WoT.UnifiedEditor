import QtQml.Models 2.11
import QtQuick 2.11
import WGTools.AnimSequences 1.0
import Panels.SequenceTimeline.Menus 1.0

Loader {
	id: loader

	readonly property int _index: index

	focus: true
	source: switch (itemData.itemType) {
		case SequenceItemTypes.Group:
			return "Delegates/GroupSequenceTreeItem.qml";
		case SequenceItemTypes.Object:
			return "Delegates/ObjectSequenceTreeItem.qml";
		case SequenceItemTypes.CompoundTrack:
		case SequenceItemTypes.Track:
			return itemData.isSound()
				? "Delegates/SoundTrackSequenceTreeItem.qml"
				: "Delegates/TrackSequenceTreeItem.qml"
		default:
			return "Delegates/BaseSequenceTreeItem.qml";
	}

	ContextMenuTreeItem {
		id: itemPopup
	}

	MouseArea {
		propagateComposedEvents: true
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		anchors.fill: parent
		z: 200

		property bool selectionHandled: false

		function handleSelection(mouse) {
			var thisModelIndex = sourceModelAdapter.mapToModel(thisDelegateModel.modelIndex(loader._index))
			var flag = ItemSelectionModel.ClearAndSelect

			if (mouse.modifiers & Qt.ControlModifier) {
				flag = ItemSelectionModel.Toggle

				//check type of the current selection
				// we do not want to have keys and objects/tracks in the same selection
				if (selectionModel.hasSelection) {
					var selectedInd = rootSequenceTree.selectionModel.selectedIndexes[0]
					var type = sourceModelAdapter.model.get(selectedInd).itemData.itemType

					if (type == SequenceItemTypes.Key)
						flag = flag | ItemSelectionModel.Clear
				}
			}

			selectionModel.select(thisModelIndex, flag)
			selectionModel.setCurrentIndex(thisModelIndex, ItemSelectionModel.NoUpdate)
		}

		onWheel: {
			wheel.accepted = false
		}

		onPressed: {
			forceActiveFocus()
			selectionHandled = false

			var currentIndex = sourceModelAdapter.mapToModel(thisDelegateModel.modelIndex(loader._index))
			if (!selectionModel.isSelected(currentIndex)) {
				handleSelection(mouse)
				selectionHandled = true
			}

			if (mouse.button == Qt.RightButton && itemData.label != "Root") {
				itemPopup.popupEx()
			}

			mouse.accepted = false
		}

		onClicked: {
			if (!selectionHandled) {
				handleSelection(mouse)
			}

			mouse.accepted = false
		}

		onDoubleClicked: {
			rootSequenceTree.expand(loader.styleData.index);
			context.zoomToExtents(loader.styleData.index);

			forceActiveFocus()
			mouse.accepted = false
		}
	}
}
