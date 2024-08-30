import QtQuick 2.10
import QtQml.Models 2.2
import WGTools.PropertyGrid 1.0 as WGT

MouseArea {
	id: mouseArea

	property var propertyGrid: null

	readonly property alias currentIndex: d.currentIndex 
	readonly property alias clickedIndex: d.clickedIndex	// for debug purposes
	readonly property alias pressedIndex: d.pressedIndex	// for debug purposes

	property Item selectionFrame
	property bool selectionFrameEnabled: true
	readonly property bool frameSelectionActive: selectionFrame && selectionFrame.visible

	signal frameSelectionWheel(real delta)
	signal rightButtonClicked(real mouseX, real mouseY)

	acceptedButtons: Qt.LeftButton | Qt.RightButton
	propagateComposedEvents: true
	hoverEnabled: true
	enabled: propertyGrid && propertyGrid.selection

	function incrementCurrentIndex() {
		let oldCurrentIndex = d.currentIndex

		if (d.currentIndex != undefined) {
			d.currentIndex = rowSelector.getNextIndex(d.currentIndex)
		} else {
			d.currentIndex = rowSelector.getFirstIndex()
		}

		return oldCurrentIndex !== d.currentIndex
	}

	function decrementCurrentIndex() {
		let oldCurrentIndex = d.currentIndex

		if (d.currentIndex != undefined) {
			d.currentIndex = rowSelector.getPrevIndex(d.currentIndex)
		} else {
			d.currentIndex = rowSelector.getFirstIndex()
		}

		return oldCurrentIndex !== d.currentIndex
	}

	function selectAll() {
		if (propertyGrid == null && propertyGrid.selection == null) {
			return
		}

		let itemSelecion = rowSelector.getFullSelection()
		propertyGrid.selection.select(itemSelecion, ItemSelectionModel.Select)
	}

	function deselectAll() {
		propertyGrid.selection.clearSelection()

		if (d.currentIndex) {
			mouseSelect(d.currentIndex)
		}
	}

	function keySelect(modifiers) {
		if (!modifiers) {
			d.clickedIndex = d.currentIndex
		}

		if (!(modifiers & Qt.ControlModifier) || (modifiers & Qt.ShiftModifier)) {
			mouseSelect(d.currentIndex, modifiers)
		}
	}

	function mouseSelect(modelIndex, modifiers) {
		if (!propertyGrid.selection) {
			return
		}

		if (modifiers == null) {
			modifiers = 0
		}
		
		propertyGrid.selection.setCurrentIndex(modelIndex, ItemSelectionModel.NoUpdate)

		if (multiselection) {
			let shiftPressed = modifiers & Qt.ShiftModifier
			let ctrlPressed = modifiers & Qt.ControlModifier

			if (shiftPressed) {
				let itemSelecion = (d.clickedIndex !== modelIndex)
					? rowSelector.getSelectionForRange(d.clickedIndex, modelIndex)
					: modelIndex

				if (ctrlPressed) {
					propertyGrid.selection.select(itemSelecion, ItemSelectionModel.Select)
				} else {
					propertyGrid.selection.select(itemSelecion, ItemSelectionModel.ClearAndSelect)
				}
			} else if (ctrlPressed) {
				propertyGrid.selection.select(modelIndex, ItemSelectionModel.Toggle)
				d.clickedIndex = modelIndex
			} else {
				propertyGrid.selection.select(modelIndex, ItemSelectionModel.ClearAndSelect)
				d.clickedIndex = modelIndex
			}
		}
	}

	onPressed: {
		if (propertyGrid == null) {
			return
		}

		let item = propertyGrid.nodeAt(mouse.y)
		if (item == null) {
			return
		}

		if (item.item != null)
		{
			// TODO: find better solution
			item.guardedForceActiveFocus()
		}

		d.pressedIndex = item.modelIndex

		switch (mouse.button) {
			case Qt.LeftButton:
			{
				if (!d.clickedIndex) {
					d.clickedIndex = d.pressedIndex
				}

				mouseSelect(d.pressedIndex, mouse.modifiers)

				if (!mouse.modifiers) {
					d.clickedIndex = d.pressedIndex
				}

				if (selectionFrameEnabled && selectionFrame && (mouse.modifiers & Qt.ShiftModifier)) {
					selectionFrame.show(mouse.x, mouse.y)
				}
			}
			break

			case Qt.RightButton:
			{
				if (!propertyGrid.selection.isSelected(d.pressedIndex)) {
					mouseSelect(d.pressedIndex)
				} else {
					propertyGrid.selection.setCurrentIndex(d.pressedIndex, ItemSelectionModel.NoUpdate)
				}
			}
			break
		}
	}

	onReleased: {
		d.pressedIndex = undefined

		switch (mouse.button) {
			case Qt.LeftButton:
			{
				if (selectionFrame) {
					selectionFrame.hide()
				}
			}
			break

			case Qt.RightButton:
			{
				rightButtonClicked(mouse.x, mouse.y)
			}
			break
		}
	}

	onPositionChanged: {
		if (frameSelectionActive) {
			selectionFrame.resize(mouse.x, mouse.y)
		}
	}

	onExited: {
		d.pressedIndex = undefined
	}

	onCanceled: {
		d.pressedIndex = undefined
	}

	onWheel: {
		if (frameSelectionActive) {
			let delta = Math.round((wheel.angleDelta.y == 0 ? wheel.angleDelta.x : wheel.angleDelta.y) / 120)
			frameSelectionWheel(delta)
		} else {
			wheel.accepted = false
		}
	}

	QtObject {
		id: d
		property var clickedIndex: undefined
		property var pressedIndex: undefined
		property var currentIndex: undefined

		function reset() {
			clickedIndex = undefined
			pressedIndex = undefined
			currentIndex = propertyGrid.selection ? propertyGrid.selection.currentIndex : undefined
		}
	}

	Binding {
		target: d
		property: "currentIndex"
		value: mouseArea.propertyGrid.selection.currentIndex
		when: mouseArea.propertyGrid && mouseArea.propertyGrid.selection
	}

	Keys.onUpPressed: {
		decrementCurrentIndex()
		keySelect(event.modifiers)
	}

	Keys.onDownPressed: {
		incrementCurrentIndex()
		keySelect(event.modifiers)
	}

	WGT.PropertyGridHelper {
		id: rowSelector
		model: propertyGrid.model

		filterRole: "nodeType"
		filterString: "Property|Grid"
		filterSyntax: WGT.PropertyGridHelper.RegExp
	}

	Connections {
		target: propertyGrid
		onModelChanged: d.reset()
	}

	Connections {
		target: propertyGrid.model
		ignoreUnknownSignals: true

		onModelReset: d.reset()
		onLayoutChanged: d.reset()
		onRowsInserted: d.reset()
		onRowsMoved: d.reset()
		onRowsRemoved: d.reset()
	}
}
