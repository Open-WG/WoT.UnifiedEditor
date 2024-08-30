import QtQuick 2.11
import QtQuick.Layouts 1.11
import WGTools.PropertyGrid 1.0 as PG
import "../Common/" as Common
import "../Common/PGRow" as Common

Common.PGRow {
	id: cell

	property alias layoutHints: layoutHints

	orientation: (model && model.node.label.orientation != null) ? model.node.label.orientation : propertyGrid.orientation
	topPadding: 0
	bottomPadding: 0
	leftPadding: 0
	rightPadding: 0
	background: null

	splitter.enabled: false
	Keys.enabled: false

	label: Common.PGLabel {
		enabled: model && model.node.label.visible
		horizontalAlignment: cell.horizontal ? Text.AlignRight : Text.AlignLeft
		useGroupDepth: false
	}

	item: Common.ControlCreator {}

	PG.LayoutHints {
		id: layoutHints
		source: model ? model.node.property : null
	}
}
