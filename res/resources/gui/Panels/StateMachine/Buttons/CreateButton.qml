import QtQuick 2.11
import WGTools.Controls 2.0
import Panels.SequenceTimeline 1.0

import "../../SequenceTimeline/Toolbar/Buttons" as STButtons

STButtons.TimelineToolButton {
	iconImage: Constants.iconAddButton
	text: "Create"
	enabled: true

	ToolTip.text: "Create State Machine"

	onClicked: context.createStateMachine()
}
