import QtQuick 2.11
import QtQml.Models 2.2
import WGTools.AtlasEditor 1.0
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Controls 2.0 as Controls
import WGTools.Misc 1.0 as Misc
import WGTools.States 1.0 as States

MouseArea {
	id: root

	readonly property int idx: index

	hoverEnabled: true
	propagateComposedEvents: true

	Controls.ToolTip.text: model 
			? ("id: " + model.chunkID
			+ (model.isBusy ? ("\nLocked By: " + model.lockedBy) : "")
			+ (model.isBusy || model.myLock ? ("\nDate: " + model.lockDate) : ""))
			: ""

	Controls.ToolTip.visible: model && containsMouse

	ControlsEx.ChannelViewImage {
		id: img
		anchors.fill: parent
		visible: !isEmpty
		source: isEmpty ? "" : texture

		States.StateLoading {
			id: loading
			anchors.fill: parent
			visible: !img.isReady
		}
		onTextureChanged: {
			img.source = ""
			image.source = texture
		}

		readonly property var texture: model ? model.chunkImage : ""
		readonly property var isEmpty: texture === undefined || texture === ""
	}

	onClicked: {
		if (mouse.button == Qt.LeftButton) {
			root.forceActiveFocus()

			var selectionFlags = ItemSelectionModel.ClearAndSelect

			if (mouse.modifiers & Qt.ControlModifier) {
				selectionFlags = styleData.selection.isSelected(styleData.modelIndex)
					? ItemSelectionModel.Deselect : ItemSelectionModel.Select
			}

			styleData.selection.select(styleData.modelIndex, selectionFlags)
		}
	}
	
	Rectangle {
		id: lockStatusRect

		anchors.fill: parent

		visible: model ? (model.myLock || model.isBusy) : false

		opacity: 0.4
		color: !model || model.myLock
			? "#7ed321"
			: (model.isBusy ? "red" : "transparent")
	}

	//selection
	Rectangle {
		id: selBorder
		property var __isSelected: isSelected()
		
		anchors.fill: parent

		color: "transparent"
		opacity: __isSelected ? 1.0 : 0.5
		border { 
			color: __isSelected ? _palette.color12 : _palette.color2 ; 
			width: __isSelected ? 2 : 1
		}

		Connections {
			target: styleData.selection
			onSelectionChanged: {
				selBorder.__isSelected = selBorder.isSelected()
			}
		}

		function isSelected() {
			return styleData.selection
				? styleData.selection.isSelected(styleData.modelIndex)
				: false
		}
	}

	Misc.Text {
		visible: styleData.showNumbers && !parent.containsMouse
		text: index.toString()
		style: Text.Outline
		styleColor: _palette.color7
		color: _palette.color2
		opacity: 0.5
		leftPadding: 10
	}
}
