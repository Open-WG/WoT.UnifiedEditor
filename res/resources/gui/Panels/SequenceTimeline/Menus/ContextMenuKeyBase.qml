import WGTools.Controls 2.0
import WGTools.AnimSequences 1

Menu {
	MenuCopyPaste {}
	MenuItem {
		text: "Delete"
		visible: !context.hasOwnProperty("deleteSelectedNodes") || (itemData && itemData.itemType == SequenceItemTypes.Group)
		onTriggered:
		{
			if (context.hasOwnProperty("deleteSelectedNodes")){
				context.deleteSelectedNodes()
			}
			else {
				context.sequenceModel.deleteItems(context.selectionModel.selection)
			}
		}
	}
	MenuKeysColor {}
}
