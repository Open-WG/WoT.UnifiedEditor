import QtQuick 2.11
import WGTools.Shapes 1.0 as Shapes

Item {
	id: root
	implicitWidth: 1

	function getPosition() {
		return Math.round(context.timelineController.fromSecondsToScale(commentData.time))
	}

	Binding on x { value: root.getPosition() }
	Connections {
		target: context.timelineController
		ignoreUnknownSignals: false
		onScaleChanged: root.x = root.getPosition()
	}

	TimelineGlobalCommentRangeHighlighter {
		id: rangeHighlighter
		height: parent.height
	}

	Shapes.DashedLine {
		height: parent.height
	}
}
