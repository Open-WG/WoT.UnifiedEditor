import QtQuick 2.7
import QtQml.Models 2.2

import WGTools.AnimSequences 1.0
import WGTools.Clickomatic 1.0 as Clickomatic

import "Constants.js" as Constants
import "Helpers.js" as Helpers
import "Menus"
import "Clickomatic"

BaseKeyItem {
	function selectKeys(selModel, box, selection) {
		Helpers.selectKeys(selModel, box, keyRepeater, styleData.timelineViewID,
			selection)
	}

	Rectangle {
		color: Constants.seqKeyConnectionColor
		height: Constants.seqKeyConnectionHeight
		width: keyRepeater.lastKey && keyRepeater.firstKey
			? keyRepeater.lastKey.x - keyRepeater.firstKey.x
			: 0
		x: keyRepeater.firstKey
			? keyRepeater.firstKey.x
			: 0

		anchors.verticalCenter: parent.verticalCenter
	}

	Repeater {
		id: keyRepeater
		readonly property Item firstKey: findKey(less)
		readonly property Item lastKey: findKey(greater)

		function findKey(comparator) {
			if (count == 0) {
				return null;
			}

			var resItem = keyRepeater.itemAt(0);
			for (var i = 1; i < count; ++i) {
				var item = keyRepeater.itemAt(i)

				if (comparator(item, resItem)) {
					resItem = item
				}
			}

			return resItem
		}

		function less(lhs, rhs) {
			return lhs.x < rhs.x
		}

		function greater(lhs, rhs) {
			return lhs.x > rhs.x
		}

		model: DelegateModel {
			id: keysModel
			model: styleData.model
			rootIndex: styleData.modelIndex

			delegate: Item {
				id: keyHolder

				property var modelIndex: styleData.model ? styleData.model.mapToModel(keysModel.modelIndex(index)) : null
				property alias realWidth: key.width
				property alias realHeight: key.height

				x: getKeyPosition()

				anchors.verticalCenter: parent.verticalCenter
				anchors.alignWhenCentered: false
				
				width: 1
				height: 0

				function getKeyPosition() {
					return Math.round(styleData.timelineController.fromSecondsToScale(
								model.itemData.position))
				}

				Loader {
					id: popupLoader

					onLoaded: popupLoader.item.open()
				}

				Component {
					id: popupSimpleKey

					SimpleKeyContextMenu {}
				}

				Component {
					id: popupCurveKey

					CurveKeyContextMenu {
						sequenceModel: styleData.model.model
						selectionModel: styleData.selectionModel
					}
				}

				Rectangle {
					id: key

					property bool _selected: 
						styleData.selectionModel ? styleData.selectionModel.isSelected(keyHolder.modelIndex) : false

					width: _selected ? Constants.seqKeySelectedSize : Constants.seqKeySize
					height: width
					rotation: 45
					
					color: _selected ? Constants.seqKeySelectedColor : Constants.seqKeyColor
					border.width: 2
					border.color: _selected ? Constants.seqKeySelectedBorderColor : "transparent"

					anchors.centerIn: parent
					anchors.alignWhenCentered: false

					Connections {
						target: styleData.timelineController
						ignoreUnknownSignals: false
						onScaleChanged: {
							keyHolder.x = Qt.binding(getKeyPosition)
						}
					}

					Connections {
						target: styleData.selectionModel
						ignoreUnknownSignals: false
						onSelectionChanged: {
							var newState = styleData.selectionModel.isSelected(keyHolder.modelIndex);
							if (newState != key._selected)
								key._selected = newState
						}
					}
				}

				MouseArea {
					id: mouseAreaID
					Accessible.name: accessNameGenerator.accessibleName
					Clickomatic.ClickomaticItem.acceptsDrop: false

					property bool dragging: false
					property bool needToApplyChanges: false

					width: Constants.seqKeySelectedSize * 1.5
					height: Constants.seqTreeItemHeight

					anchors.centerIn: key

					preventStealing: true
					hoverEnabled: true
					acceptedButtons: Qt.LeftButton | Qt.RightButton

					AccessibleNameGenerator {
						id: accessNameGenerator
						model: styleData.model.model
						modelIndex: keyHolder.modelIndex
						basename: "Simplekey"
					}

					function handleSelection(mouse) {
						var ctrlPressed = mouse.modifiers & Qt.ControlModifier
						if (selectionModel.isSelected(keyHolder.modelIndex) && !ctrlPressed)
							return
							
						var flag = ItemSelectionModel.ClearAndSelect
						if (ctrlPressed) {
							flag = ItemSelectionModel.Toggle

							//check tyoe of the current selection
							// we do not want to have keys and objects/tracks in the same selection
							if (selectionModel.hasSelection) {
								var selectedInd = styleData.selectionModel.selectedIndexes[0]
								var type = styleData.model.model.get(selectedInd).itemData.itemType

								if (type != SequenceItemTypes.Key)
									flag = flag | ItemSelectionModel.Clear
							}
						}

						styleData.selectionModel.select(keyHolder.modelIndex, flag)
					}

					onPressed: {
						forceActiveFocus()
						handleSelection(mouse);
						
						if (mouse.button == Qt.LeftButton) {
							dragging = true
						}
					}

					onReleased: {
						if (mouse.button == Qt.LeftButton) {
							dragging = false

							if (needToApplyChanges)
							{
								multiKeyHelper.finalize(true)
								needToApplyChanges = false
							}
						}
					}

					MultiKeyHelper {
						id: multiKeyHelper

						context: styleData.context
					}

					onPositionChanged: {
						if (dragging) {
							var rect = mapToItem(styleData.timelineViewID, mouse.x, mouse.y)
							var frame = styleData.timelineController.fromScreenToScaleClipped(rect.x)
							var seconds = styleData.timelineController.fromFramesToSeconds(frame)

							multiKeyHelper.moveKeys(seconds - model.itemData.position, 0)

							needToApplyChanges = true
						}
					}

					onClicked: {
						if (mouse.button == Qt.RightButton) {
							var point = mapToItem(keyHolder, mouse.x, mouse.y)
							popupLoader.x = point.x
							popupLoader.y = point.y

							if (!context.sequenceModel.sameTypeKeys(context.selectionModel.selection)) {
								popupLoader.source = "Menus/BaseKeyContextMenu.qml"
								return
							}

							if (styleData.keyType == SequenceItemTypes.SimpleKey)
								popupLoader.sourceComponent = popupSimpleKey
							else
								popupLoader.sourceComponent = popupCurveKey
						}
					}

					Connections {
						target: popupLoader.item

						onClosed: {
							popupLoader.sourceComponent = null
						}
					}
				}
			}
		}
	}
}
