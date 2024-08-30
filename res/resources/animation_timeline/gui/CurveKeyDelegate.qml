import QtQuick 2.7
import QtQml.Models 2.2

import SeqTreeItemTypes 1.0
import TangentModes 1.0
import MultiKeyHelper 1.0

import "Debug"
import "Constants.js" as Constants
import "Menus"

Item {
	id: root

	width: 1

	signal selectionChanged()

	property var curveEditorController: null
	property var selectionModel: null
	property var context: null
	property var keyDeleteSignalHolder: null
	property var modelIndex: null
	property var isSelected: checkSelection()
	property var combinerHeight: null
	property alias curveViewID: tangentController.curveViewID
	property alias timelineViewID: tangentController.timelineViewID

	property alias realWidth: keyComponent.width
	property alias realHeight: keyComponent.height

	visible: y + realHeight > 0 && y - realHeight < combinerHeight
	y: getKeyYPosition()

	Connections {
		target: curveEditorController
		ignoreUnknownSignals: false
		onScaleChanged: {
			y = Qt.binding(getKeyYPosition)
		}
	}

	Connections {
		target: selectionModel
		ignoreUnknownSignals: true
		onSelectionChanged: {
			root.isSelected = checkSelection()
		}
	}

	function getKeyYPosition() {
		return compositeHolder.height -
			curveEditorController.fromScaleToScreen(itemKeyStoredValue) -
			height / 2
	}

	function checkSelection() {
		return root.selectionModel ? root.selectionModel.isSelected(modelIndex) : false
	}

	Rectangle {
		id: selectionFrame

		antialiasing: true

		color: "white"
		visible: root.isSelected
		
		rotation: 45

		width: Constants.seqKeySize + 4
		height: width

		z: keyComponent.z - 1

		anchors.centerIn: parent
	}

	TangentControllerItem {
		id: tangentController

		property bool tangentIsBroken: itemKeyBrokenTangentMode

		rightHandleRotation: getRightRotation()
		leftHandleRotation: getLeftRotation()

		visible: root.isSelected
		independentHandles: tangentIsBroken

		color: "white"

		keyPosition: itemKeyPosition
		keyValue: itemKeyStoredValue

		curveController: curveEditorController
		curveMappingOffset: root.combinerHeight

		anchors.centerIn: keyComponent

		onVisibleChanged: {
			if (visible) {
				rightHandleRotation = Qt.binding(getRightRotation)
				leftHandleRotation = Qt.binding(getLeftRotation)
			}
		}

		function getLeftRotation() {
			return getRotation(itemKeyInTangentValue, itemKeyInTangentMode)
		}

		function getRightRotation() {
			return getRotation(itemKeyOutTangentValue, itemKeyOutTangentMode)
		}

		function getRotation(tangent, mode) {
			//we need to convert x coordinatee to frames, since our scale is frame based and curve is in seconds
			var dir = Qt.vector2d(context.timelineController.fromSecondsToFrames(1), tangent).normalized();

			var xPixel = context.timelineController.fromScaleToScreen(
				context.timelineController.start + dir.x)
			var yPixel = curveEditorController.fromScaleToScreen(curveEditorController.start + dir.y)

			var dirMapped = Qt.vector2d(xPixel, yPixel).normalized()

			var angle = -Math.atan2(dirMapped.y, dirMapped.x) * (180 / Math.PI)

			if (mode == TangentModes.STEPPED) {
				if (angle > 0) {
					return 90
				}
				else {
					return -90
				}
			}

			return angle
		}

		onInTangentChanged: {
			var newVal = val

			if (tangentIsBroken) {
				if (turnToStepped) {
					itemKeyInTangentMode = TangentModes.STEPPED
				}
				else {
					itemKeyInTangentMode = TangentModes.FREE
					itemKeyInTangentValue = newVal
				}
			}
			else {
				if (turnToStepped) {
					itemKeyInTangentMode = TangentModes.STEPPED
					itemKeyOutTangentMode = TangentModes.STEPPED
				}
				else {
					itemKeyInTangentMode = TangentModes.FREE
					itemKeyOutTangentMode = TangentModes.FREE

					itemKeyInTangentValue = newVal
					itemKeyOutTangentValue = newVal
				}
			}
		}

		onOutTangentChanged: {
			var newVal = val

			if (tangentIsBroken) {
				if (turnToStepped) {
					itemKeyOutTangentMode = TangentModes.STEPPED
				}
				else {
					itemKeyOutTangentMode = TangentModes.FREE
					itemKeyOutTangentValue = newVal
				}
			}
			else {
				if (turnToStepped) {
					itemKeyInTangentMode = TangentModes.STEPPED
					itemKeyOutTangentMode = TangentModes.STEPPED
				}
				else {
					itemKeyInTangentMode = TangentModes.FREE
					itemKeyOutTangentMode = TangentModes.FREE

					itemKeyInTangentValue = newVal
					itemKeyOutTangentValue = newVal
				}
			}
		}

		onNeedToApplyChanges: {
			itemFinalizeKey = false
		}
	}

	Loader {
		id: popupLoader
	}

	Component {
		id: popupCurveKey

		CurveKeyContextMenu {
			visible: true

			sequenceModel: context.sequenceTreeModel
			selectionModel: root.selectionModel
		}
	}

	Rectangle {
		id: keyComponent

		antialiasing: true

		rotation: 45

		color: itemCurveComponentColor

		width: Constants.seqKeySize
		height: width

		anchors.centerIn: parent

		MouseArea {
			anchors.fill: parent

			property bool dragging: false
			property bool needToApplyChanges: false

			acceptedButtons: Qt.LeftButton | Qt.RightButton
			preventStealing: true
			
			function handleSelection(mouse) {
				var ctrlPressed = mouse.modifiers & Qt.ControlModifier

				if (root.selectionModel.isSelected(root.modelIndex) && !ctrlPressed)
					return

				context.beginUndoRedoBarrier("tangentSelectionBarrier", false);

				var flag = ItemSelectionModel.ClearAndSelect
				if (ctrlPressed) {
					flag = ItemSelectionModel.Toggle

					//check tyoe of the current selection
					// we do not want to have keys and objects/tracks in the same selection
					if (root.selectionModel.hasSelection) {
						var selectedInd = root.selectionModel.selectedIndexes[0]

						if (itemType != SeqTreeItemTypes.Key)
							flag = flag | ItemSelectionModel.Clear
					}
				}

				selectionModel.select(modelIndex, flag)
				selectionChanged()

				context.endUndoRedoBarrier()
			}

			MultiKeyHelper {
				id: multiKeyHelper

				context: root.context
			}

			onPressed: {
				forceActiveFocus()

				handleSelection(mouse)

				dragging = true
			}

			onReleased: {
				dragging = false

				if (needToApplyChanges) {
					multiKeyHelper.finalize(true)
					needToApplyChanges = false
				}
			}

			onClicked: {
				if (mouse.button == Qt.RightButton) {
					var point = mapToItem(root, mouse.x, mouse.y)
					popupLoader.x = point.x
					popupLoader.y = point.y

					popupLoader.sourceComponent = popupCurveKey
				}
			}

			onPositionChanged: {
				if (dragging) {
					var rect = mapToItem(timelineViewID, mouse.x, mouse.y)
					var frame = context.timelineController.fromScreenToScaleClipped(rect.x)
					var seconds = context.timelineController.fromFramesToSeconds(frame)

					var rectCurveView = mapToItem(curveViewID, mouse.x, mouse.y)

					var compValue = combinerHeight - rectCurveView.y
					if (compValue < 0)
						compValue = 0
					else if (compValue > combinerHeight)
						compValue = combinerHeight

					compValue = curveEditorController.fromScreenToScale(compValue)

					multiKeyHelper.moveKeys(seconds - itemKeyPosition, compValue - itemKeyStoredValue)

					needToApplyChanges = true
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