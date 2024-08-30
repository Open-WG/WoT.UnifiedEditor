import QtQuick 2.11
import WGTools.Controls 2.0
import "../Common/" as Details
import "../Common/PGRow" as Details

Details.PGRow {
	id: row
	active: styleData.active
	selected: styleData.selected
	orientation: (model && model.node.label.orientation != null) ? model.node.label.orientation : propertyGrid.orientation

	splitter.sharedData: propertyGrid.splitterSharedData

	Accessible.name: model ? model.node.name : ""

	label: Details.PGLabel {
		selected: styleData.selected
		enabled: model && model.node.label.visible
		horizontalAlignment: Text.AlignLeft
	}

	item: Loader {
		source: model ? "Layouts/" + model.node.layout + ".qml" : ""
	}
}
