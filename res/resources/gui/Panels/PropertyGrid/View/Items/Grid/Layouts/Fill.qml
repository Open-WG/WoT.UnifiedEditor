import QtQuick 2.11
import QtQuick.Layouts 1.11
import WGTools.Controls.Details 2.0
import "Details" as Details
import "../" as Details

RowLayout {
	id: layout
	spacing: ControlsSettings.spacing
	width: 0 // binding loop fix

	Details.ChildrenRepeater {
		id: repeater
		delegate: Details.GridCell {
			Layout.alignment: layoutHints.alignment
			Layout.fillWidth: layoutHints.fillWidth
			Layout.fillHeight: layoutHints.fillHeight
			Layout.minimumWidth: layout.width * layoutHints.minimumWidth
			Layout.maximumWidth: layout.width * layoutHints.maximumWidth
			Layout.preferredWidth: layoutHints.stretchFactor > 0 ? layout.width * layoutHints.stretchFactor : -1
		}
	}
}
