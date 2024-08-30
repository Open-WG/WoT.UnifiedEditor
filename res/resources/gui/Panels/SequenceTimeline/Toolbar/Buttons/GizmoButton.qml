import QtQuick 2.11
import WGTools.Controls 2.0
import Panels.SequenceTimeline 1.0

TimelineToolButton {
	text: "Gizmo"
	ToolTip.text: "Show gizmo for model to move"

	enabled: context.sequenceOpened
	checkable: true
	iconImage: Constants.iconGizmo
	iconColor: "transparent"

	onClicked: {
		context.gizmoEnabled = !context.gizmoEnabled
		context.chowModelGizmo()
	}
}