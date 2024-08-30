import QtQuick 2.11
import WGTools.Controls 2.0
import Panels.SequenceTimeline 1.0

import "../../SequenceTimeline/Toolbar/Buttons" as STButtons

STButtons.TimelineToolButton {
	iconImage: Constants.iconOpen
	text: "Open"
	enabled: true

	ToolTip.text: "Open State Machine"
	
	onClicked: context.openStateMachine()
}
