import QtQuick 2.7
import QtQml.Models 2.2

import SeqTreeItemTypes 1.0
import QMLCursor 1.0

import "Constants.js" as Constants
import "Menus"
import "Debug"
import "Dialogs"

Column {
	id: treeItem

	property real treeColumnWidth: 0
	property var sourceModelAdapter: null
	property var thisDelegateModel: null
	property var selectionModel: null
	property var viewOwner: null

	function placeKey() {
		maKeyPlacer.maTryPlaceKey()
	}

	function selectItems(selModel, box, selection) {
		secondLoader.item.selectKeys(selModel, box, selection)
		if (curveEditorLoader.visible)
			curveEditorLoader.item.selectKeys(selModel, box, selection)
	}

	Rectangle {
		width: parent.width
		height: Constants.seqObjSeparatorHeight

		visible: index != 0 && itemType == SeqTreeItemTypes.Object

		color: Constants.seqObjSeparatorColor
	}

	Row {
		id: firstRow

		Loader {
			id: firstLoader
			width: treeColumnWidth
			readonly property int _index: index

			signal testSign(var type)

			property QtObject styleData: QtObject {
				readonly property var view: rootSequenceTree
				readonly property var index: sourceModelAdapter.mapToModel(thisDelegateModel.modelIndex(firstLoader._index))
				readonly property var selectionModel: rootSequenceTree.selectionModel
				readonly property bool expanded: isExpanded
				readonly property var context : rootSequenceTree.rootContext
				property var addTrackSignHolder: firstLoader

				property var curveEditorEnabled: false
			} 

			onTestSign: {
				itemAddTrack = type
			}

			function treeItemChooser() {
				switch (itemType)
				{
					case SeqTreeItemTypes.Object:
				 		return "ObjectSequenceTreeItem.qml";
			 		case SeqTreeItemTypes.CompoundTrack:
				 	case SeqTreeItemTypes.Track:
				 		return "TrackSequenceTreeItem.qml"
					default:
						return "BaseSequenceTreeItem.qml";
				}
			}

			Component.onCompleted: {
				firstLoader.setSource(treeItemChooser(),
									styleData);
			}

			Loader {
				id: popupLoader
			}

			NormalizePositionDialog {
				id: normalizePositionDialog

				parent: mainWindow

				x: mainWindow.width / 2
				y: mainWindow.height / 2

				width: 250
				height: 150

				onAccepted: {
					model.itemAutoSplitPath = autoSplitVal
					model.itemNormalizePathSpeed = value
				}
			}

			Component {
				id: popupComp

				SeqTreeItemContextMenu {
					id: itemPopup

					visible: true
					modelData: model

					onDeleteTriggered: {
						rootSequenceTree.deleteIndices()
					}

					onNormalizePosDialogTriggered: {
						normalizePositionDialog.curveLength = model.itemCurveLength
						normalizePositionDialog.value = model.itemDuration
						normalizePositionDialog.autoSplitVal = model.itemAutoSplitPath
						normalizePositionDialog.open()
					}
				}
			}

			MouseArea {
				anchors.fill: parent
				propagateComposedEvents: true
				acceptedButtons: Qt.LeftButton | Qt.RightButton

				function handleSelection(mouse) {
					var thisModelIndex = sourceModelAdapter.mapToModel(thisDelegateModel.modelIndex(firstLoader._index));
					var ctrlPressed = mouse.modifiers & Qt.ControlModifier

					var flag = ItemSelectionModel.ClearAndSelect
					if (ctrlPressed) {
						flag = ItemSelectionModel.Toggle

						//check tyoe of the current selection
						// we do not want to have keys and objects/tracks in the same selection
						if (selectionModel.hasSelection) {
							var selectedInd = rootSequenceTree.selectionModel.selectedIndexes[0]
							var type = modelAdapter.model.get(selectedInd).itemType

							if (type == SeqTreeItemTypes.Key) {
								flag = flag | ItemSelectionModel.Clear
							}
						}
					}

					selectionModel.select(thisModelIndex, flag)
				}

				onWheel: {
					wheel.accepted = false
				}

				onPressed: {
					forceActiveFocus()

					handleSelection(mouse)

					if (mouse.button == Qt.RightButton) {
						if (itemLabel != "Root") {
							var point = mapToItem(treeItem, mouse.x, mouse.y)
							popupLoader.x = point.x
							popupLoader.y = point.y
							popupLoader.sourceComponent = popupComp
						}
					}

					mouse.accepted = false
				}

				Connections {
					target: popupLoader.item
					
					onClosed: {
						popupLoader.sourceComponent = null
					}
				}

				onReleased: {
				}

				onDoubleClicked: {
					forceActiveFocus()
					mouse.accepted = false
				}

				onClicked: {
				}
			}
		}

		Loader {
			id: secondLoader

			width: viewOwner.contentWidth 
				- rootSequenceTree.treeColumnWidth - rootSequenceTree.spacing
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

				readonly property var keyType: itemKeyTrackType
			}

			Loader {
				id: trackPopupLoader
			}

			Component {
				id: trackPopup

				TrackContextMenu {
					id: trackPopupMenu
					visible: true

					onAddKeyPressed: {
						var mappedIndex = sourceModelAdapter.mapRowToModelIndex(index)
						var frame = rootSequenceTree.timelineController.fromScreenToScaleClipped(trackPopupLoader.x)
						var seconds = rootSequenceTree.timelineController.fromFramesToSeconds(frame)

						tryPlaceKey(mappedIndex, seconds)
					}
				}
			}

			Connections {
				target: trackPopupLoader.item
				onClosed: {
					trackPopupLoader.sourceComponent = null
				}
			}

			MouseArea {
				id: maKeyPlacer

				anchors.fill: parent

				propagateComposedEvents: true
				acceptedButtons: Qt.LeftButton | Qt.RightButton

				onPressed: {
					if (mouse.button == Qt.RightButton) {
						var point = mapToItem(secondLoader, mouse.x, mouse.y)
						trackPopupLoader.x = point.x
						trackPopupLoader.y = point.y

						trackPopupLoader.sourceComponent = trackPopup
					}

					mouse.accepted = false
				}

				onDoubleClicked: {
					maTryPlaceKey()
				}

				function maTryPlaceKey() {
					if (!containsMouse) {
						return
					}

					var mappedIndex = sourceModelAdapter.mapRowToModelIndex(index)
					var frame = rootSequenceTree.timelineController.fromScreenToScaleClipped(mouseX)
					var seconds = rootSequenceTree.timelineController.fromFramesToSeconds(frame)

					tryPlaceKey(mappedIndex, seconds)
				}
			}

			function keyItemChooser() {
				switch (itemKeyTrackType) {
					case SeqTreeItemTypes.SimpleKey:
					case SeqTreeItemTypes.CurveKey:
						return "SimpleKeyItem.qml"
					case SeqTreeItemTypes.ContainerKey:
						return "ContainerKeyItem.qml"
					default:
						return ""
				}
			}
		}
	}

	Row {
		id: curveEditorRow

		Loader {
			id: curveEditorDisplay

			width: treeColumnWidth

			active: firstLoader.styleData.curveEditorEnabled
			visible : firstLoader.styleData.curveEditorEnabled

			source: "CurveEditorValueDisplay.qml"

			onActiveChanged: treeItem.forceLayout()

			property QtObject styleData: QtObject {
				readonly property var proxy: model.itemCurveTrackDisplay
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
			
			width: viewOwner.contentWidth 
				- rootSequenceTree.treeColumnWidth - rootSequenceTree.spacing
			height: curveEditorDisplay.height

			active: firstLoader.styleData.curveEditorEnabled
			visible : firstLoader.styleData.curveEditorEnabled

			source: "CurveEditorView.qml"

			property QtObject styleData: QtObject {
				readonly property var context : rootSequenceTree.rootContext
				readonly property var sourceModel: index != -1 ? sourceModelAdapter : null
				readonly property var modelIndex: index != -1 ? thisDelegateModel.modelIndex(index) : null
				readonly property var trackProxy: model.itemCurveTrackDisplay
				readonly property var curveContainer: model.itemCurveContainer ? model.itemCurveContainer.curves : null
				readonly property var selectionModel: rootSequenceTree.selectionModel
				readonly property var timelineViewID: rootSequenceTree.timelineViewID
				readonly property var keyDeleteSignalHolder: rootSequenceTree
			}

			onActiveChanged: treeItem.forceLayout()
		}
	}
}
