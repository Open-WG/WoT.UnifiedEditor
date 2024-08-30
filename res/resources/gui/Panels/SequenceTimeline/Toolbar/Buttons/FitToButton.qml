import QtQuick 2.11
import Panels.SequenceTimeline 1.0

TimelineToolButton {
	property var curveView

	text: "FitTo"
	iconImage: Constants.iconFocus
	enabled: context.sequenceOpened
	onClicked: {
		Helpers.focusSequence(context)

		if (context.curveMode && curveView) {
			curveView.item.fitScale()
		}
	}
}
