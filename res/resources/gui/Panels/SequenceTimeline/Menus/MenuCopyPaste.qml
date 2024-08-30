import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.AnimSequences 1.0

Menu {
	id: copyPasteMenu
	title: "Copy/Paste"
	enabled: (itemData && itemData.itemType != SequenceItemTypes.Group) && context.hasOwnProperty("deleteSelectedNodes")

	Binding {
		target: copyPasteMenu.parent
		property: "visible"
		value: copyPasteMenu.enabled
	}

	MenuItem {
		text: "Copy"
		onTriggered: context.copySelectedNodes()
	}

	MenuItem {
		text: "Paste"
		onTriggered: context.pasteNodes()
	}

	MenuItem {
		text: "Duplicate"
		onTriggered: context.cloneSelectedNodes()
	}

	MenuItem {
		text: "Cut"
		onTriggered: context.cutSelectedNodes()
	}

	MenuItem {
		text: "Delete"
		onTriggered: context.deleteSelectedNodes()
	}
}
