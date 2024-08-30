import QtQuick 2.11
import WGTools.Controls 2.0
import Panels.SequenceTimeline 1.0

TimelineToolButton {
	text: "Help"
	iconImage: Constants.iconFeedback
	onClicked: context.openFeedbackURL()

	ToolTip.text: "Feedback"
}
