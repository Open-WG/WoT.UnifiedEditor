import QtQuick 2.10
import QtQuick.Layouts 1.3
import WGTools.Controls.Details 2.0
import "Details" as Details
import "../" as Details

Item {
	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight

	ColumnLayout {
		id: layout
		width: parent.width
		height: Math.min(implicitHeight, parent.height)
		spacing: ControlsSettings.spacing

		Details.ChildrenRepeater {
			delegate: Details.GridCell {
				Layout.fillHeight: true
			}
		}
	}
}
