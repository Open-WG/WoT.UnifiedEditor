import QtQuick 2.7
import QtQml.Models 2.2

import WGTools.AnimSequences 1.0
import WGTools.Utils.QMLCursor 1.0 as QMLCursor

import "Constants.js" as Constants
import "Menus"
import "Dialogs"

Column {
	id: treeItem

	property real treeColumnWidth: 0
	property var sourceModelAdapter: null
	property var thisDelegateModel: null
	property var selectionModel: null
	property var viewOwner: null

	function placeKey() { maKeyPlacer.maTryPlaceKey() }

	function selectItems(selModel, box, selection) {
		if (timeLineTrackLoader.item)
		{
			timeLineTrackLoader.item.selectKeys(selModel, box, selection)
			if (curveEditorLoader.visible)
				curveEditorLoader.item.selectKeys(selModel, box, selection)
		}
	}

	Rectangle {
		id: treeItemSeparator
		width: parent.width
		height: Constants.seqObjSeparatorHeight // 3
		visible: index != 0 && !!itemData && itemData.itemType == SequenceItemTypes.Object
		color: Constants.seqObjSeparatorColor // gray
	}

	Row {
		id: firstRow

		Loader {
			id: treeItemLoader
			width: treeColumnWidth
			readonly property int _index: index
			//visible: isVisible()
			signal testSign(var type)

			focus: true

			property QtObject styleData: QtObject {
				readonly property var view: rootSequenceTree
				readonly property var index: sourceModelAdapter.mapToModel(thisDelegateModel.modelIndex(treeItemLoader._index))
				readonly property var selectionModel: rootSequenceTree.selectionModel
				readonly property bool expanded: isExpanded
				readonly property var context : rootSequenceTree.rootContext
				property var addTrackSignHolder: treeItemLoader

				property var curveEditorEnabled: false
			}

			onTestSign: { itemAddTrack = type }

			function treeItemChooser() {
				switch (itemData.itemType)
				{
					case SequenceItemTypes.Object:
				 		return "ObjectSequenceTreeItem.qml";
			 		case SequenceItemTypes.CompoundTrack:
				 	case SequenceItemTypes.Track:
				 		return "TrackSequenceTreeItem.qml"
					default:
						return "BaseSequenceTreeItem.qml";
				}
			}

			Component.onCompleted: { treeItemLoader.setSource(treeItemChooser(), styleData); }

			SeqTreeItemContextMenu {
				id: itemPopup

				visible: false

				onDeleteTriggered: context.sequenceModel.deleteItems(context.selectionModel.selection)

				onNormalizePosDialogTriggered: {
					itemPopup.close()
					itemData.normalize()
				}
			}

			MouseArea {
				anchors.fill: parent
				propagateComposedEvents: true
				acceptedButtons: Qt.LeftButton | Qt.RightButton

				function handleSelection(mouse) {
					var thisModelIndex = sourceModelAdapter.mapToModel(thisDelegateModel.modelIndex(treeItemLoader._index));
					var ctrlPressed = mouse.modifiers & Qt.ControlModifier

					var flag = ItemSelectionModel.ClearAndSelect
					if (ctrlPressed) {
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
				}

				onWheel: { wheel.accepted = false }

				onPressed: {
					forceActiveFocus()

					handleSelection(mouse)

					if (mouse.button == Qt.RightButton) {
						if (itemData.label != "Root") {
							var point = mapToItem(treeItem, mouse.x, mouse.y)
							itemPopup.x = point.x
							itemPopup.y = point.y
							itemPopup.open()
						}
					}

					mouse.accepted = false
				}

				// Connections {
				// 	target: popupLoader.item
				// 	onClosed: {	popupLoader.sourceComponent = null }
				// }

				onDoubleClicked: {
					rootSequenceTree.expand(treeItemLoader.styleData.index);
					context.zoomToExtents(treeItemLoader.styleData.index);

					forceActiveFocus()
					mouse.accepted = false
				}
			}
		}

		Loader {
			id: timeLineTrackLoader
			Accessible.name: "Track"

			width: viewOwner.contentWidth - rootSequenceTree.treeColumnWidth - rootSequenceTree.spacing
			source: keyItemChooser()

			property QtObject styleData: QtObject {
				readonly property var model: index != -1 ? sourceModelAdapter : null
				readonly property var modelIndex: index != -1 ? thisDelegateModel.modelIndex(index) : null
				readonly property var context : rootSequenceTree.rootContext

				readonly property var selectionModel: rootSequenceTree.selectionModel
				readonly property var timelineController: rootSequenceTree.timelineController
				readonly property var keyMoveSignalHolder : rootSequenceTree
				readonly property var keyDeleteSignalHolder : rootSequenceTree
				readonly property var timelineViewID: rootSequenceTree.timelineViewID

				readonly property var keyType: itemData.keyType
			}

			TrackContextMenu {
				id: trackPopupMenu
				visible: false

				onAddKeyPressed: {
					var frame = rootSequenceTree.timelineController.fromScreenToScaleClipped(trackPopupMenu.x)
					var seconds = rootSequenceTree.timelineController.fromFramesToSeconds(frame)
					model.itemData.insertKeyAt(seconds)
				}
			}

			MouseArea {
				id: maKeyPlacer

				anchors.fill: parent

				propagateComposedEvents: true
				acceptedButtons: Qt.LeftButton | Qt.RightButton

				onPressed: {
					if (mouse.button == Qt.RightButton) {
						var point = mapToItem(timeLineTrackLoader, mouse.x, mouse.y)
						trackPopupMenu.x = point.x
						trackPopupMenu.y = point.y
						trackPopupMenu.open()
					}

					mouse.accepted = false
				}

				onDoubleClicked: { maTryPlaceKey() }

				function maTryPlaceKey() {
					if (!containsMouse) {
						return
					}

					var frame = rootSequenceTree.timelineController.fromScreenToScaleClipped(mouseX)
					var seconds = rootSequenceTree.timelineController.fromFramesToSeconds(frame)
					model.itemData.insertKeyAt(seconds)
				}
			}

			function keyItemChooser() {
				switch (itemData.keyType) {
					case SequenceItemTypes.SimpleKey:
					case SequenceItemTypes.CurveKey:
						return "SimpleKeyItem.qml"
					case SequenceItemTypes.ContainerKey:
						return "ContainerKeyItem.qml"
					default:
						return ""
				}
			}
		}
	}

	Row {
		id: curveEditorRow
		Accessible.name: "Curve Editor"

		Loader {
			id: curveEditorDisplay

			width: treeColumnWidth

			active: treeItemLoader.styleData.curveEditorEnabled
			visible : treeItemLoader.styleData.curveEditorEnabled

			source: "CurveEditorValueDisplay.qml"

			onActiveChanged: treeItem.forceLayout()

			property QtObject styleData: QtObject {
				readonly property var proxy: itemData.decomposedValues
				readonly property var context : rootSequenceTree.rootContext
			}

			Binding on height {
				value: sizer.y + sizer.height
				when: sizer.drag.active
			}

			MouseArea {
				id: sizer

				width: parent.width
				height: 10
				anchors.bottom: drag.active ? undefined : parent.bottom

				y: Constants.curveEditorHeight
				z: 100
				cursorShape: Qt.SizeVerCursor
				hoverEnabled: true
				preventStealing: true

				drag.target: sizer
				drag.axis: Drag.YAxis
				drag.threshold: 0
				drag.minimumY: Constants.curveEditorHeight - height
			}
		}

		Loader {
			id: curveEditorLoader

			width: viewOwner.contentWidth - rootSequenceTree.treeColumnWidth - rootSequenceTree.spacing
			height: curveEditorDisplay.height

			active: treeItemLoader.styleData.curveEditorEnabled
			visible : treeItemLoader.styleData.curveEditorEnabled

			source: "CurveEditorView.qml"

			property QtObject styleData: QtObject {
				readonly property var context : rootSequenceTree.rootContext
				readonly property var sourceModel: index != -1 ? sourceModelAdapter : null
				readonly property var modelIndex: index != -1 ? thisDelegateModel.modelIndex(index) : null
				readonly property var trackProxy: itemData.decomposedValues
				readonly property var curveContainer: itemData.curveContainer ? itemData.curveContainer.curves : null
				readonly property var selectionModel: rootSequenceTree.selectionModel
				readonly property var timelineViewID: rootSequenceTree.timelineViewID
				readonly property var keyDeleteSignalHolder: rootSequenceTree

				property bool isScaleInitialized: false  // autocalculate scale only on first curve open
			}

			onActiveChanged: treeItem.forceLayout()
		}
	}
}
