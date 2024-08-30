import QtQuick 2.11
import QtQml.Models 2.2

import WGTools.AnimSequences 1.0
import WGTools.Misc 1.0 as Misc
import WGTools.Utils 1.0 as Utils

import "../Constants.js" as Constants

Rectangle{
	id: root
	color: "black"
	border.color: Constants.labelBorderColor
	
	MultiEventHelper {
		id: multiEventHelper

		timelineContext: context
	}

	SelectionHelper {
		id: selectionHelper

		model: context.eventSelectionModel
	}

	Misc.SelectionBox {
		id: selBox
		enabled: context.eventSelectionModel
		anchors.fill: parent

		onSelectionFinished: {
			for (var i = 0; i < repeater.count; ++i) {
				var item = repeater.itemAt(i)

				if (Utils.Geometry.overlap(x, y, width, height,
						item.x, item.y, 
						item.mouseArea.width, item.mouseArea.height)) {
					var numRows = eventModelAdapter.rowCount(item.modelIndex)
					for (var j = 0; j < numRows; ++j) {
						var childIndex = eventModelAdapter.index(j, 0, item.modelIndex)
						selectionHelper.push(eventModelAdapter.getData(childIndex).sourceIndex)
					}
				}
			}

			if (modifiers == Qt.ControlModifier)
				selectionHelper.flush(ItemSelectionModel.Select)
			else
				selectionHelper.flush(ItemSelectionModel.ClearAndSelect)
		}

		onSelectionFailed: {
			context.eventSelectionModel.clearSelection()
		}
	}

	MouseArea {
		property bool __dragging: false
		property bool __needToApplyChanges: false
		property var __sourceIndex

		anchors.fill: parent
		acceptedButtons: Qt.LeftButton
		hoverEnabled: true

		function processSelection(hitItem, modifiers) {
			var numRows = eventModelAdapter.rowCount(hitItem.modelIndex)
			for (var i = 0; i < numRows; ++i) {
				var childIndex = eventModelAdapter.index(i, 0, hitItem.modelIndex)
				if (context.eventSelectionModel.isSelected(eventModelAdapter.getData(childIndex).sourceIndex)) {
					if (modifiers == Qt.ControlModifier) {
						selectionHelper.push(eventModelAdapter.getData(childIndex).sourceIndex)
						selectionHelper.flush(ItemSelectionModel.Deselect)
						return null
					}
					else
						return eventModelAdapter.getData(childIndex).sourceIndex
				}
			}
			
			for (var i = 0; i < numRows; ++i) {
				var childIndex = eventModelAdapter.index(i, 0, hitItem.modelIndex)
				selectionHelper.push(eventModelAdapter.getData(childIndex).sourceIndex)
			}

			if (modifiers == Qt.ControlModifier)
				selectionHelper.flush(ItemSelectionModel.Select)
			else
				selectionHelper.flush(ItemSelectionModel.ClearAndSelect)

			if (context.eventSelectionModel.hasSelection) {
				var childIndex = eventModelAdapter.index(0, 0, hitItem.modelIndex)
				return eventModelAdapter.getData(childIndex).sourceIndex
			}

			return null
		}

		onPressed: {
			if (mouse.button == Qt.LeftButton) {
				var hitItem = repeater.hitTestChildren(mouse.x, mouse.y)
				if (hitItem) {
					__dragging = true
					__sourceIndex = processSelection(hitItem, mouse.modifiers)
				}
				else
					mouse.accepted = false
			}
		}

		onReleased: {
			if (mouse.button == Qt.LeftButton) {
				__dragging = false
				__sourceIndex = null

				if (__needToApplyChanges)
				{
					multiEventHelper.finalize(true)
					__needToApplyChanges = false
				}
			}
		}

		onPositionChanged: {
			if (__dragging) {
				var rect = mapToItem(root, mouse.x, mouse.y)
				var frame = context.timelineController.fromScreenToScaleClipped(rect.x)
				var seconds = context.timelineController.fromFramesToSeconds(frame)

				multiEventHelper.moveEvents(seconds -
					context.sequenceEventModel.getData(__sourceIndex).time)

				__needToApplyChanges = true
			}
		}
		onDoubleClicked: {
			if (!repeater.hitTestChildren(mouse.x, mouse.y)) {
				var frame = context.timelineController.fromScreenToScaleClipped(mouseX)
				var seconds = context.timelineController.fromFramesToSeconds(frame)
				context.sequenceEventModel.insertEvent(seconds)
			}
		}
	}

	Connections {
		target: context.timelineActionManager
		onDeleteItem: context.sequenceEventModel.deleteEvents(
			context.eventSelectionModel.selection)
	}

	EventModelAdapter {
		id: eventModelAdapter
		model: context.sequenceEventModel
	}

	Repeater {
		id: repeater
		model: DelegateModel {
			id: eventModel

			model: eventModelAdapter

			delegate: AggregatedEvent {
				anchors.top: parent.top
				anchors.bottom: parent.bottom

				model: eventModelAdapter
				modelIndex: eventModel.modelIndex(index)
				viewID: root
			}
		}

		function hitTestChildren(x, y) {
			for (var i = 0; i < repeater.count; ++i) {
				var item = repeater.itemAt(i)
				var rect = mapToItem(item.mouseArea, x, y)
				if (item.mouseArea.contains(rect))
					return item
			}
			return null
		}
	}
}
