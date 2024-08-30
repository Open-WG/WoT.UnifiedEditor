import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import "../Common/" as Details
import "../Common/PGRow" as Details
import "../Common/ActionBar" as Details

Details.PGRow {
	id: row
	active: styleData.active
	selected: styleData.selected
	orientation: (model && model.node.label.orientation != null) ? model.node.label.orientation : propertyGrid.orientation

	splitter.sharedData: propertyGrid.splitterSharedData

	Accessible.name: model ? model.node.label.text : ""

	label: Details.PGLabel {
		selected: styleData.selected
		enabled: model && model.node.label.visible
		horizontalAlignment: Text.AlignLeft
	}

	item: Item {
		id: layout
		implicitWidth: cc.implicitWidth + spacing + ab.implicitWidth
		implicitHeight: Math.max(cc.implicitHeight, ab.implicitHeight)

		readonly property real spacing: ControlsSettings.spacing
		
		Details.ControlCreator {
			id: cc
			width: layout.width - ab.width - (ab.width != 0 ? layout.spacing : 0)
			height: layout.height
		}

		Details.ActionBar {
			id: ab
			x: layout.width - width
			y: (parent.height - height) / 2
			actions: model ? model.node.actions : null
			placeholderCount: model
				? model.node.actionPlaceholderCount
				: 0
		}
	}
}
