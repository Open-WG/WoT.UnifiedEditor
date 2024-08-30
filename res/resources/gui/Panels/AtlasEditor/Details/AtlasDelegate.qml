import QtQuick 2.11
import QtQml.Models 2.2
import WGTools.AtlasEditor 1.0
import WGTools.Controls.Details 2.0 as ControlsDetails
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.States 1.0 as States

MouseArea {
	id: root

	readonly property int idx: index

	hoverEnabled: true

	onClicked: {
		root.forceActiveFocus()
		
		if (!flickable.dragging && styleData.selection) {
			var selectionFlags = ItemSelectionModel.ClearAndSelect
	
			if (mouse.modifiers & Qt.ControlModifier) {
				selectionFlags = selectionListener.selected ? ItemSelectionModel.Deselect : ItemSelectionModel.Select
			}
	
			selectionListener.selection.select(styleData.modelIndex, selectionFlags)
		}
	}

	ControlsEx.ChannelViewImage {
		id: img

		readonly property var texture: model && model.atlasSlot != undefined 
				? model.atlasSlot.textures[styleData.settings.tileType]
				: undefined
		readonly property var isEmpty: texture == undefined || texture == ""

		width: parent.width
		height: parent.height
		source: isEmpty ? "" : texture
		visible: !isEmpty

		States.StateLoading {
			id: loading
			width: parent.width
			height: parent.height
			visible: !img.isReady
		}

		Binding { target: img.effect; property: "redEnabled";   value: styleData.settings.red;   when: flickable.settings }
		Binding { target: img.effect; property: "greenEnabled"; value: styleData.settings.green; when: flickable.settings }
		Binding { target: img.effect; property: "blueEnabled";  value: styleData.settings.blue;  when: flickable.settings }
		Binding { target: img.effect; property: "alphaEnabled"; value: styleData.settings.alpha; when: flickable.settings }
	}

	TilePlaceholder {
		width: parent.width
		height: parent.height
		visible: showEmptySlotIcons && !img.visible
	}

	AtlasSelectionHelper {
		id: selectionListener
		selection: styleData.selection ? styleData.selection : null
		index: idx
	}
	
	//selection
	Rectangle {
		width: parent.width
		height: parent.height
		color: "transparent"
		opacity: selectionListener.selected ? 1.0 : 0.5
		visible: styleData.showGrid || selectionListener.selected || root.containsMouse
		border {
			color: selectionListener.selected ? _palette.color12 : _palette.color2 ; 
			width: selectionListener.selected ? 2 : 1
		}
	}

	Text {
		visible: isVisible(index)
		text: getText(index)
		style: Text.Outline
		styleColor: "black"
		color: _palette.color2
		padding: 3
		font.family: ControlsSettings.fontFamily
		font.pixelSize: ControlsSettings.textNormalSize
		font.bold: true

		function isVisible(index) {
			if (!styleData.showNumbers)
				return false;

			if (styleData.rowColumnNumbers)
				return isFirstRow(index) || isFirstColumn(index)

			return !parent.containsMouse
		}

		function isFirstRow(index) {
			return index < styleData.columnCount
		}

		function isFirstColumn(index) {
			return index % styleData.rowCount == 0
		}

		function getText(index) {
			if (styleData.rowColumnNumbers) {
				if (isFirstRow(index)) {
					return (index + 1).toString()
				}
				else if (isFirstColumn(index)) {
					return index / styleData.rowCount + 1
				}

				return ""
			}

			return index.toString()
		}
	}
}
