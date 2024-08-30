import QtQuick 2.11
import WGTools.Controls.Details 2.0
import WGTools.PropertyGrid 1.0 as PG
import "Details" as Details
import "../" as Details

Flow {
	spacing: ControlsSettings.spacing

	PG.GridLayoutHints {
		id: gridLayoutHints
		node: model ? model.node : null
	}

	Details.MaxImplicitWidthCalc {
		id: maxImplicitWidth
		parent: gridLayoutHints.equalWidths ? repeater : null
	}

	Details.ChildrenRepeater {
		id: repeater
		delegate: Details.GridCell {
			width: Math.min(Math.max(implicitWidth, maxImplicitWidth.value), parent.width)
		}
	}
}
