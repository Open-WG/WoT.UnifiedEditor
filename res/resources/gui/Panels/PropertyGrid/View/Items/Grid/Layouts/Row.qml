import QtQuick 2.10
import QtQuick.Layouts 1.3
import WGTools.Controls.Details 2.0
import WGTools.PropertyGrid 1.0 as PG
import "Details" as Details
import "../" as Details
import "../../Common/ActionBar" as Details

Item {
	id: item
	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight

	PG.GridLayoutHints {
		id: gridLayoutHints
		node: model ? model.node : null
	}

	Details.MaxImplicitWidthCalc {
		id: maxImplicitWidth
		parent: gridLayoutHints.equalWidths ? repeater : null
	}

	RowLayout {
		id: layout
		width: Math.min(implicitWidth, parent.width)
		height: parent.height
		spacing: ControlsSettings.spacing

		Binding on x {when: gridLayoutHints.alignment == Qt.AlignLeft; value: 0}
		Binding on x {when: gridLayoutHints.alignment == Qt.AlignRight; value: item.width - layout.width}

		Details.ChildrenRepeater {
			id: repeater
			delegate: Details.GridCell {
				Layout.fillWidth: true
				Layout.preferredWidth: maxImplicitWidth.value
			}
		}
	}

	Details.ActionBar {
			id: ab
			x: item.width - width
			y: (item.height - height) / 2
			actions: model ? model.node.actions : null
			placeholderCount: model
				? model.node.actionPlaceholderCount
				: 0
			shortcutEnabled: row.activeFocus
		}
}
