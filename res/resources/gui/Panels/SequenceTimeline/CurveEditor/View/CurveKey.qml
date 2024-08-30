import QtQuick 2.7
import QtQml.Models 2.2

import WGTools.AnimSequences 1.0

import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.Menus 1.0

Item {
	id: root

	property var curveEditorController: null
	property var selectionModel: null
	property var modelIndex: null
	property var isSelected: checkSelection()
	property var combinerHeight: null
	property var model: null
	property alias curveViewID: tangentController.curveViewID
	property alias timelineViewID: tangentController.timelineViewID

	property alias realWidth: keyComponent.width
	property alias realHeight: keyComponent.height

	signal selectionChanged()

	width: 1
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
		return compositeHolder.height - curveEditorController.fromValueToPixels(itemData.value) - height / 2
	}

	function checkSelection() {
		return root.selectionModel ? root.selectionModel.isSelected(modelIndex) : false
	}

	Rectangle {
		id: selectionFrame
		width: Constants.keySize + 4
		height: width
		rotation: 45
		color: "white"
		visible: root.isSelected
		antialiasing: true
		z: keyComponent.z - 1

		anchors.centerIn: parent
	}

	TangentControllerItem {
		id: tangentController

		property bool tangentIsBroken: itemData && itemData.hasOwnProperty("isBrokenTangent") && itemData.isBrokenTangent

		rightHandleRotation: getRightRotation()
		leftHandleRotation: getLeftRotation()

		visible: root.isSelected
		independentHandles: tangentIsBroken

		color: "white"

		keyPosition: itemData.position
		keyValue: itemData.value

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
			return getRotation(itemData.inTangentValue, itemData.inTangentMode)
		}

		function getRightRotation() {
			return getRotation(itemData.outTangentValue, itemData.outTangentMode)
		}

		function getRotation(tangent, mode) {
			//we need to convert x coordinatee to frames, since our scale is frame based and curve is in seconds
			var dir = Qt.vector2d(context.timelineController.fromSecondsToFrames(1), tangent).normalized();

			var xPixel = context.timelineController.fromValueToPixels(context.timelineController.visibleStart + dir.x)
			var yPixel = curveEditorController.fromValueToPixels(curveEditorController.visibleStart + dir.y)

			var dirMapped = Qt.vector2d(xPixel, yPixel).normalized()

			var angle = -Math.atan2(dirMapped.y, dirMapped.x) * (180 / Math.PI)
			//console.log(">>angle", angle)
			if (mode == TangentMode.STEPPED) {
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
					itemData.inTangentMode = TangentMode.STEPPED
				}
				else {
					itemData.inTangentMode = TangentMode.FREE
					itemData.inTangentValue = newVal
				}
			}
			else {
				if (turnToStepped) {
					itemData.inTangentMode = TangentMode.STEPPED
					itemData.outTangentMode = TangentMode.STEPPED
				}
				else {
					itemData.inTangentMode = TangentMode.FREE
					itemData.outTangentMode = TangentMode.FREE

					itemData.inTangentValue = newVal
					itemData.outTangentValue = newVal
				}
			}
		}

		onOutTangentChanged: {
			var newVal = val

			if (tangentIsBroken) {
				if (turnToStepped) {
					itemData.outTangentMode = TangentMode.STEPPED
				}
				else {
					itemData.outTangentMode = TangentMode.FREE
					itemData.outTangentValue = newVal
				}
			}
			else {
				if (turnToStepped) {
					itemData.inTangentMode = TangentMode.STEPPED
					itemData.outTangentMode = TangentMode.STEPPED
				}
				else {
					itemData.inTangentMode = TangentMode.FREE
					itemData.outTangentMode = TangentMode.FREE

					itemData.inTangentValue = newVal
					itemData.outTangentValue = newVal
				}
			}
		}

		onNeedToApplyChanges: {
			itemData.finalize()
		}
	}

	Loader {
		id: popupLoader
	}

	Component {
		id: popupCurveKey

		ContextMenuKeyCurve {
			visible: true
		}
	}

	Rectangle {
		id: keyComponent
		width: Constants.keySize
		height: width
		color: itemData && itemData.hasOwnProperty("curveComponentColor") ? itemData.curveComponentColor : "black"
		rotation: 45
		antialiasing: true

		anchors.centerIn: parent

		MouseArea {
			id: ma

			readonly property var _context: context

			property bool dragging: false
			property bool needToApplyChanges: false

			acceptedButtons: Qt.LeftButton | Qt.RightButton
			preventStealing: true

			anchors.fill: parent

			function handleSelection(mouse) {
				var ctrlPressed = mouse.modifiers & Qt.ControlModifier

				if (root.selectionModel.isSelected(root.modelIndex) && !ctrlPressed)
					return

				var flag = ItemSelectionModel.ClearAndSelect
				if (ctrlPressed) {
					flag = ItemSelectionModel.Toggle

					//check type of the current selection
					// we do not want to have keys and objects/tracks in the same selection
					if (root.selectionModel.hasSelection) {
						var selectedInd = root.selectionModel.selectedIndexes[0]

						if (itemType != SeqTreeItemTypes.Key)
							flag = flag | ItemSelectionModel.Clear
					}
				}

				selectionModel.select(modelIndex, flag)
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

					compValue = curveEditorController.fromPixelsToValue(compValue)

					multiKeyHelper.moveKeys(seconds - itemData.position)
					multiKeyHelper.setValues(compValue - itemData.value)

					needToApplyChanges = true
				}
			}

			Connections {
				target: popupLoader.item
				onClosed: {
					popupLoader.sourceComponent = null
				}
			}

			MultiKeyHelper {
				id: multiKeyHelper
				context: ma._context
			}
		}
	}
}
