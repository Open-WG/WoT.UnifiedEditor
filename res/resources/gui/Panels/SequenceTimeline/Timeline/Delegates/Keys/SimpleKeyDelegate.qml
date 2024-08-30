import QtQuick 2.11
import QtQml.Models 2.2

import WGTools.AnimSequences 1.0
import WGTools.Clickomatic 1.0 as Clickomatic

import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.Menus 1.0
import Panels.SequenceTimeline.Clickomatic 1.0
import Panels.SequenceTimeline.Comments 1.0

Item {
	id: keyHolder

	property var modelIndex: null
	property alias realWidth: key.width
	property alias realHeight: key.height
	property int selectedIndexOffset: 0

	anchors.verticalCenter: parent.verticalCenter
	anchors.alignWhenCentered: false
	
	width: 0
	height: 0
	z: index + (key.state == "selected" ? selectedIndexOffset : 0)

	/**************************************************************
	 * position
	 */
	function getKeyPosition() {
		return Math.round(styleData.timelineController.fromSecondsToScale(model.itemData.position))
	}

	Binding on x { value: keyHolder.getKeyPosition() }
	Connections {
		target: styleData.timelineController
		ignoreUnknownSignals: false
		onScaleChanged: {
			keyHolder.x = keyHolder.getKeyPosition()
		}
	}

	/**************************************************************
	 * popups
	 */
	Loader {
		id: popupLoader
		onLoaded: popupLoader.item.popupEx()
	}

	Component {
		id: popupSimpleKey
		ContextMenuKeySimple {}
	}

	Component {
		id: popupCurveKey
		ContextMenuKeyCurve {}
	}

	/**************************************************************
	 * appearance
	 */
	SimpleKey {
		id: key

		anchors.centerIn: parent
		anchors.alignWhenCentered: false

		function calcState() {
			if (styleData.selectionModel && styleData.selectionModel.isSelected(keyHolder.modelIndex))
				return "selected"

			return ""
		}

		Binding on state { value: "selected"; when: key.calcState() }
		Connections {
			target: styleData.selectionModel
			ignoreUnknownSignals: false
			onSelectionChanged: key.state = key.calcState()
		}
	}

	/**************************************************************
	 * interaction
	 */
	MouseArea {
		id: mouseAreaID

		Accessible.name: accessNameGenerator.accessibleName
		Clickomatic.ClickomaticItem.acceptsDrop: false

		property bool dragging: false
		property bool needToApplyChanges: false

		width: Constants.keySelectedSize * 1.5
		height: Constants.seqTreeItemHeight
		preventStealing: true
		hoverEnabled: true
		acceptedButtons: Qt.LeftButton | Qt.RightButton

		anchors.centerIn: key

		function handleSelection(mouse) {
			var ctrlPressed = mouse.modifiers & Qt.ControlModifier
			if (selectionModel.isSelected(keyHolder.modelIndex) && !ctrlPressed)
				return
				
			var flag = ItemSelectionModel.ClearAndSelect
			if (ctrlPressed) {
				flag = ItemSelectionModel.Toggle

				//check type of the current selection
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

				if (needToApplyChanges) {
					multiKeyHelper.finalize(true)
					needToApplyChanges = false
				}
			}
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
				if (!context.sequenceModel.sameTypeKeys(context.selectionModel.selection)) {
					popupLoader.source = "../../../Menus/ContextMenuKeyBase.qml"
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
			onClosed: popupLoader.sourceComponent = null
		}

		AccessibleNameGenerator {
			id: accessNameGenerator
			model: styleData.model.model
			modelIndex: keyHolder.modelIndex
			basename: "Simplekey"
		}

		MultiKeyHelper {
			id: multiKeyHelper
			context: styleData.context
		}
	}

	// there is maximum one comment, repeater is used to extract comment from model
	Repeater {
		id: commentRepeater
		model: itemData.commentsModel
		delegate: Comment {
			y: -Constants.barHeight / 2
			timelineViewID: styleData.timelineViewID
		}
	}
}
