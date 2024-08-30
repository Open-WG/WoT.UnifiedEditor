import QtQuick 2.11

import WGTools.AnimSequences 1.0

Item {
	id: root

	property var modelIndex: null
	property var model: null
	property var accessibleName: ""
	property var basename: ""

	function generateName() {
		var name = basename + modelIndex.row
		var ind = modelIndex;

		while (model.parent(ind).row != -1 && model.parent(ind).column != -1) {
			ind = model.parent(ind)
			if (model.get(ind).itemData.itemType == SequenceItemTypes.Track
				|| model.get(ind).itemData.itemType == SequenceItemTypes.CompoundTrack) {
				name = model.get(ind).itemData.label + ind.row + name
			}
			else if (model.get(ind).itemData.itemType == SequenceItemTypes.Object) {
				name = model.get(ind).itemData.label +  ind.row + name 
			}
		}

		root.accessibleName = name
	}

	onModelIndexChanged: {
		if (!model || !modelIndex) {
			root.accessibleName = ""
			return
		}

		generateName()
	}

	onModelChanged: {
		if (!model || !modelIndex) {
			root.accessibleName = ""
			return
		}

		generateName()
	}
}
