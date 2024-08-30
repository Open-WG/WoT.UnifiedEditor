import QtQuick 2.11
import QtQml.Models 2.2
import QtGraphicalEffects 1.0

import WGTools.AnimSequences 1.0 as Sequences
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Misc 1.0 as Misc
import WGTools.Debug 1.0

import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.Menus 1.0
import Panels.SequenceTimeline.Comments 1.0

BaseKeyItem {
	id: root

	function selectKeys(box, selection) {
		Helpers.selectKeys(box, keyRepeater, styleData.timelineViewID, selection)
	}

	Repeater {
		id: keyRepeater

		model: DelegateModel {
			id: keyModel
			model: index != -1 ? styleData.model : null
			rootIndex: delegateModel.modelIndex(index)

			delegate: Item {
				id: keyHolder

				readonly property var modelIndex: styleData.model ? styleData.model.mapToModel(keyModel.modelIndex(index)) : -1
				readonly property alias realWidth: key.width
				readonly property alias realHeight: key.height

				height: Constants.barHeight
				z: 0

				anchors.verticalCenter: parent.verticalCenter

				// position and width
				function getKeyPosition() {
					return Math.round(styleData.timelineController.fromSecondsToScale(itemData.position))
				}

				function getKeyWidth() {
					var width = Math.round(styleData.timelineController.fromSecondsToScale(itemData.position + itemData.duration) - keyHolder.x)

					return width > 2 ? width : 20
				}

				Binding on width { value: keyHolder.getKeyWidth() }
				Binding on x { value: keyHolder.getKeyPosition() }

				Connections {
					target: styleData.timelineController
					ignoreUnknownSignals: false
					onScaleChanged: {
						keyHolder.width = keyHolder.getKeyWidth()
						keyHolder.x = keyHolder.getKeyPosition()
					}
				}

				// context menu
				Misc.MenuLoader {
					id: menuLoader

					property var itemTime

					menuComponent: ContextMenuKeyContainer {}
					onLoaded: item.time = itemTime
					
					Connections {
						target: mouseArea
						onClicked: if (mouse.button == Qt.RightButton) {
							var point = mapToItem(styleData.timelineViewID, mouse.x, 0)
							var frame = styleData.timelineController.fromScreenToScaleClipped(point.x)

							menuLoader.itemTime = styleData.timelineController.fromFramesToSeconds(frame)
							menuLoader.popup()
						}
					}
				}

				// appearance
				ContainerKey {
					id: key

					property bool _selected: styleData.selectionModel && styleData.selectionModel.isSelected(keyHolder.modelIndex)
					
					property var timelineController: styleData.timelineController
					property var timelineViewID: styleData.timelineViewID

					state: _selected ? "selected" : ""
					croppedResource: itemData.resourceCropped

					anchors.fill: parent

					Sequences.BlendItem {
						id: blendInItem

						property real _scale

						width: _scale - keyHolder.x
						height: parent.height

						function calcScale() {
							return Math.round(styleData.timelineController.fromSecondsToScale(itemData.position + itemData.blendInTime))
						}

						Binding on _scale { value: blendInItem.calcScale() }
					}

					Sequences.BlendItem {
						id: blendOutItem

						property real _blendOutPosX

						width: keyHolder.width - _blendOutPosX
						height: parent.height
						blendIn: false
						
						anchors.right: parent.right

						function calcBlendOutPosX() {
							return Math.round(styleData.timelineController.fromSecondsToScale(itemData.position + itemData.duration - itemData.blendOutTime)) - keyHolder.x
						}

						Binding on _blendOutPosX { value: blendOutItem.calcBlendOutPosX() }
					}

					Connections {
						target: styleData.timelineController
						ignoreUnknownSignals: false
						onScaleChanged: {
							blendInItem._scale = blendInItem.calcScale()
							blendOutItem._blendOutPosX = blendOutItem.calcBlendOutPosX()
						}
					}

					Item {
						id: labels

						anchors {
							verticalCenter: parent.verticalCenter

							left: blendInItem.right
							right: blendOutItem.left

							leftMargin: 5
							rightMargin: 5
						}

						Label {
							id: keyLabel
							text: itemData.value
							elide: Text.ElideLeft
							clip: true
							color: Qt.lighter(key.barColor, 1.5)

							anchors {
								verticalCenter: parent.verticalCenter

								left: parent.left
								right: croppedLabel.left
							}

							font {
								bold: key._selected
								pixelSize: 11
							}
						}
					
						Label {
							id: croppedLabel
							text: key.croppedResource ? " [cropped]" : ""
							color: Qt.lighter(key.barColor, 1.5)
							leftPadding: key.croppedResource ? 20 : 0 // add some space between labels

							anchors {
								verticalCenter: parent.verticalCenter
								right: parent.right
							}

							font {
								bold: key._selected
								pixelSize: 12
							}
						}
					}

					Item {
						readonly property bool validPosition:
							(x >= blendInItem.x + blendInItem.width) && 
							(x <= blendOutItem.x)

						x: mouseArea.mouseX

						ToolTip.text: keyLabel.text
						ToolTip.visible: mouseArea.containsMouse && validPosition
						ToolTip.delay: ControlsSettings.tooltipDelay
						ToolTip.timeout: ControlsSettings.tooltipTimeout
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
						id: mouseArea

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

								//check type of the current selection
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
					}

					MouseArea {
						id: leftDurSizer
						Accessible.name: "Left sizer"

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

					Repeater {
						id: commentRepeater
						model: itemData.commentsModel
						delegate: Comment {
							timelineViewID: key.timelineViewID
						}
					}
				}
			}
		}
	}
}
