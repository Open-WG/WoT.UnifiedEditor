import QtQuick 2.11
import WGTools.Controls 2.0
import Panels.SequenceTimeline 1.0

TimelineToolButton {
	enabled: context.markedForSave
	iconImage: Constants.iconSave
	text: "Save"
	onClicked: context.saveSequence()

	ToolTip.text: "Save Sequence"
}
