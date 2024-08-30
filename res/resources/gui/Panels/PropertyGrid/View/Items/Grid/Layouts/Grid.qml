import QtQuick 2.10
import QtQuick.Layouts 1.3
import WGTools.Controls.Details 2.0
import "Details" as Details
import "../" as Details

GridLayout {
	id: layout
	readonly property int count: repeater.count
	columnSpacing: ControlsSettings.spacing
	rowSpacing: ControlsSettings.spacing
	columns: {
		if (maxImplicitWidth.value <= 0)
			return 1

		var c = 1
		var w = columnSpacing + maxImplicitWidth.value * 2
		
		while (w <= width) {
			c += 1
			w += columnSpacing + maxImplicitWidth.value
		}

		return c
	}

	Details.MaxImplicitWidthCalc {
		id: maxImplicitWidth
		parent: repeater
	}

	Details.ChildrenRepeater {
		id: repeater
		delegate: Details.GridCell {
			Layout.preferredWidth: Math.min(implicitWidth, layout.width)
		}
	}
}
