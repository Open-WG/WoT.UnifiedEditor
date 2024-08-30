import QtQuick 2.7
import QtQml.Models 2.2
import QtGraphicalEffects 1.0

import WGTools.AnimSequences 1.0 as Sequences
import WGTools.Clickomatic 1.0 as Clickomatic

import "Constants.js" as Constants
import "Helpers.js" as Helpers
import "Clickomatic"
import "Menus"

BaseKeyItem {
	id: root

	function selectKeys(selModel, box, selection) {
		Helpers.selectKeys(selModel, box, keyRepeater, styleData.timelineViewID,
			selection)
	}

	Repeater {
		id: keyRepeater

		model: DelegateModel {
			id: keyModel
			model: index != -1 ? styleData.model : null
			rootIndex: delegateModel.modelIndex(index)

			delegate: Item {
				id: keyHolder
				Accessible.name: accessNameGenerator.accessibleName
				Clickomatic.ClickomaticItem.acceptsDrop: false;

				property var modelIndex: styleData.model ? styleData.model.mapToModel(keyModel.modelIndex(index)) : -1
				property alias realWidth: key.width
				property alias realHeight: key.height

				AccessibleNameGenerator {
					id: accessNameGenerator
					model: styleData.model.model
					modelIndex: keyHolder.modelIndex
					basename: "Containerkey"
				}

				function getKeyPosition() {
					return Math.round(
							styleData.timelineController.fromSecondsToScale(
								itemData.position))
				}

				function getKeyWidth() {
					var width = Math.round(
							styleData.timelineController.fromSecondsToScale(
								itemData.position + itemData.duration) - keyHolder.x)

					return width > 2 ? width : 2
				}

				function recalculateLabelPosition() {
					keyLabel.anchors.horizontalCenter = key.horizontalCenter
					var center = keyLabel.x

					var p = mapToItem(styleData.timelineViewID, keyLabel.x, 0)

					var keyEnd = styleData.timelineViewID.width - keyLabel.implicitWidth

					if (p.x < 0) {
						keyLabel.anchors.horizontalCenter = undefined
						keyLabel.x = center - p.x
					}
					else if (p.x > keyEnd) {
						keyLabel.anchors.horizontalCenter = undefined
						keyLabel.x = center + (keyEnd - p.x)
					}
					else {
						keyLabel.anchors.horizontalCenter = key.horizontalCenter
					}
				}

				height: Constants.seqContainerKeyHeight
				width: getKeyWidth() 

				x: getKeyPosition()
				z: 0

				anchors.verticalCenter: parent.verticalCenter

				onXChanged: recalculateLabelPosition()
				onWidthChanged: recalculateLabelPosition()

				Loader {
					id: popupLoader
				}

				Component {
					id: popupContainerKey

					ContainerKeyContextMenu {
						visible: true
					}
				}

				Rectangle {
					id: key

					clip: true

					property bool _selected: styleData.selectionModel 
						? styleData.selectionModel.isSelected(keyHolder.modelIndex)
						: false

					color: Constants.seqContainerKeyColor
					opacity: 0.7

					anchors.fill: parent

					Sequences.BlendItem {
						id: blendInItem

						anchors.left: parent.left

						height: parent.height
						width: Math.round(
							styleData.timelineController.fromSecondsToScale(
								itemData.position + itemData.blendInTime)) - keyHolder.x
					}

					Sequences.BlendItem {
						id: blendOutItem

						readonly property real _blendOutPosX: Math.round(
							styleData.timelineController.fromSecondsToScale(
								itemData.position + itemData.duration - itemData.blendOutTime)) 
								- keyHolder.x

						anchors.right: parent.right

						blendIn: false

						height: parent.height
						width: keyHolder.width - _blendOutPosX
					}

					Rectangle {
						anchors.fill: parent

						color: "transparent"

						border.color: key._selected ? Constants.seqContainerKeySelectedBorderColor : "transparent"
						border.width: Constants.seqContainerKeySelectedBorderWidth
					}

					Text {
						id: keyLabel

						text: itemData.value

						font.family: Constants.proximaRg
						font.pixelSize: Constants.seqContainerKeyResFontSize
						font.bold: key._selected

						color: Constants.seqContainerKeyResColor

						anchors.verticalCenter: parent.verticalCenter
					}

					Connections {
						target: styleData.timelineController
						ignoreUnknownSignals: false
						onScaleChanged: {
							keyHolder.x = Qt.binding(getKeyPosition)
							keyHolder.width = Qt.binding(getKeyWidth)
						}
					}

					Connections {
						target: styleData.selectionModel
						ignoreUnknownSignals: false
						onSelectionChanged: {
							key._selected = styleData.selectionModel.isSelected(keyHolder.modelIndex)

							if (key._selected) {
								rootSequenceTree.containerTopZValue += 0.0001
								keyHolder.z = rootSequenceTree.containerTopZValue
							}
						}
					}

					MouseArea {
						property bool dragging: false
						property bool needToApplyChanges: false

						property var offsetX: 0

						anchors.fill: parent
						preventStealing: true

						acceptedButtons: Qt.LeftButton | Qt.RightButton
						hoverEnabled: true

						function handleSelection(mouse) {
							var ctrlPressed = mouse.modifiers & Qt.ControlModifier
							if (styleData.selectionModel.isSelected(keyHolder.modelIndex) && !ctrlPressed)
								return
								
							var flag = ItemSelectionModel.ClearAndSelect
							if (ctrlPressed) {
								flag = ItemSelectionModel.Toggle

								//check tyoe of the current selection
								// we do not want to have keys and objects/tracks in the same selection
								if (selectionModel.hasSelection) {
									var selectedInd = styleData.selectionModel.selectedIndexes[0]
									var type = styleData.model.model.get(selectedInd).itemData.itemType

									if (type != Sequences.SequenceItemTypes.Key)
										flag = flag | ItemSelectionModel.Clear
								}
							}

							styleData.selectionModel.select(keyHolder.modelIndex, flag)
						}	

						Sequences.MultiKeyHelper {
							id: multiKeyHelper

							context: styleData.context
						}

						onPressed: {
							forceActiveFocus()

							handleSelection(mouse)

							dragging = true
							offsetX = mouse.x
						}

						onReleased: {
							dragging = false
							offsetX = 0

							if (needToApplyChanges)
							{
								multiKeyHelper.finalize(true)
								needToApplyChanges = false
							}
						}

						onPositionChanged: {
							if (dragging) {
								var rect = mapToItem(styleData.timelineViewID, mouse.x, mouse.y)
								var frame = styleData.timelineController.fromScreenToScaleClipped(rect.x - offsetX)
								var seconds = styleData.timelineController.fromFramesToSeconds(frame)

								multiKeyHelper.moveKeys(seconds - itemData.position, 0)
								needToApplyChanges = true;
							}
						}

						onClicked: {
							if (mouse.button == Qt.RightButton) {
								var point = mapToItem(keyHolder, mouse.x, mouse.y)
								popupLoader.x = point.x
								popupLoader.y = point.y

								popupLoader.sourceComponent = popupContainerKey
							}
						}
					}

					MouseArea {
						id: leftDurSizer
						Accessible.name: "Left sizer"
						Clickomatic.ClickomaticItem.acceptsDrop: false;

						property var dragging: false

						enabled: itemData.resizable

						height: parent.height
						width: Constants.seqContainerKeySizerWidth
						z: 15

						cursorShape: itemData.resizable ? Qt.SizeHorCursor : Qt.ArrowCursor
						preventStealing: true
						hoverEnabled: true

						anchors.left: parent.left

						drag.axis: Drag.XAxis

						onPressed: {
							dragging = true

							parent = styleData.timelineViewID
							anchors.fill = parent

							styleData.selectionModel.select(keyHolder.modelIndex, ItemSelectionModel.ClearAndSelect)
						}

						onReleased: {
							dragging = false

							anchors.fill = undefined

							parent = key

							width = Constants.seqContainerKeySizerWidth
							anchors.left = parent.left

							model.itemData.finalize()
						}

						onPositionChanged: {
							if (!dragging) {
								return
							}
							
							var frame = styleData.timelineController.fromScreenToScaleClipped(mouse.x)
							var seconds = styleData.timelineController.fromFramesToSeconds(frame)
							var minDuration = styleData.timelineController.fromFramesToSeconds(1)
							var prevItemPos = itemData.position
							var finalItemDur = itemData.duration - (seconds - prevItemPos)

							itemData.startTime = seconds
						}
					}

					MouseArea {
						id: rightDurSizer
						Accessible.name: "Right sizer"
						Clickomatic.ClickomaticItem.acceptsDrop: false;

						property var dragging: false

						enabled: itemData.resizable

						height: parent.height
						width: Constants.seqContainerKeySizerWidth
						z: leftDurSizer.z + 1

						cursorShape: itemData.resizable ? Qt.SizeHorCursor : Qt.ArrowCursor
						preventStealing: true
						hoverEnabled: true

						anchors.right: parent.right

						drag.axis: Drag.XAxis

						onPressed: {
							dragging = true

							parent = styleData.timelineViewID
							anchors.fill = parent

							styleData.selectionModel.select(keyHolder.modelIndex, ItemSelectionModel.ClearAndSelect)
						}

						onReleased: {
							dragging = false

							anchors.fill = undefined

							parent = key

							width = Constants.seqContainerKeySizerWidth
							anchors.right = parent.right

							model.itemData.finalize()
						}

						onPositionChanged: {
							if (!dragging)
								return
							
							var frame = styleData.timelineController.fromScreenToScaleClipped(mouse.x)
							var seconds = styleData.timelineController.fromFramesToSeconds(frame)
							var minDuration = styleData.timelineController.fromFramesToSeconds(1)

							var finalValue = seconds - itemData.position

							if (finalValue >= minDuration)
							 	itemData.endTime = seconds
							else
								itemData.endTime = itemData.position + minDuration
						}
					}

					Connections {
						target: popupLoader.item
						onClosed: popupLoader.sourceComponent = null
					}
				}
			}
		}
	}
}
