import QtQuick 2.10
import QtQuick.Layouts 1.3
import "Details" as Details
import "../" as Details
import "../../../Settings.js" as Settings

GridLayout {
	id: layout
	columns: 4
	columnSpacing: Settings.gridSpacing
	rowSpacing: Settings.gridSpacing

	Details.ChildrenRepeater {
		id: repeater

		delegate: Details.GridCell {
			readonly property bool isCell: index == 0

			Layout.rowSpan: isCell ? Math.max(1, (repeater.count - 1) / 2) : 1
			Layout.columnSpan: isCell ? 2 : 1
			Layout.preferredWidth: isCell ? 2 : 1

			Layout.fillWidth: true
			Layout.fillHeight: true
		}
	}
}
