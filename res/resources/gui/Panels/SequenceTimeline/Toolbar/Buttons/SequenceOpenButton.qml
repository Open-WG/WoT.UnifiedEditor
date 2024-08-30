import QtQuick 2.11
import WGTools.Controls 2.0
import Panels.SequenceTimeline 1.0

TimelineToolButton {
	iconImage: Constants.iconOpen
	text: "Open"
	enabled: context.modelSelected
	onClicked: context.openSequence()

	ToolTip.text: "Open Sequence"
}
