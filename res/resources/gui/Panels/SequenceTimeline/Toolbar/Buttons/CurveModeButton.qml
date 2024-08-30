import QtQuick 2.11
import WGTools.Controls 2.0
import Panels.SequenceTimeline 1.0

TimelineToolButton {
	text: "Curve"
	checkable: true
	iconImage: Constants.iconCurves
	iconColor: "transparent"
	enabled: context.sequenceOpened

	Binding on checked { value: context.curveMode }
	onClicked: {
		context.curveMode = !context.curveMode
		checked = context.curveMode
	}

	ToolTip.text: "Toggle Curve Mode"
}
