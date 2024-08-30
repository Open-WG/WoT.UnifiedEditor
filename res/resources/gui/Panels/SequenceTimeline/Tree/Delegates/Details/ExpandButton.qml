import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.AnimSequences 1.0
import Panels.SequenceTimeline 1.0

Button {
	Accessible.name: "Expand"

	width: 25
	height: Constants.seqTreeItemHeight
	visible: (itemData.isExpandable && hasChildren) || (itemData.keyType == SequenceItemTypes.CurveKey && itemData.curveContainer != null)
	rotation: getRotation()
	focusPolicy: Qt.NoFocus
	
	background: Item {
		implicitWidth: 25
		implicitHeight: 25
	}

	contentItem: Image {
		source: Constants.iconCollapseExpand
		fillMode: Image.Pad
		verticalAlignment: Image.AlignVCenter

		sourceSize.width: 6
		sourceSize.height: 12
	}

	onClicked: {
		if (isCurveTrack())
			styleData.curveEditorEnabled = !styleData.curveEditorEnabled
		else
			if (styleData.expanded)
				styleData.view.collapse(styleData.index)
			else
				styleData.view.expand(styleData.index)
	}

	function getRotation() {
		if (isCurveTrack())
			return styleData.curveEditorEnabled ? 90 : 0
		else
			return styleData.expanded ? 90 : 0
	}

	function isCurveTrack() {
		return itemData.itemType == SequenceItemTypes.CompoundTrack
	}
}
