import QtQuick 2.11
import WGTools.Debug 1.0

Item {
	id: root
	
	Repeater {
		model: context.globalComments

		TimelineGlobalCommentMarker {
			id: line
			height: parent.height
			anchors.bottom: parent.bottom

			function getPosition() {
				return Math.round(context.timelineController.fromSecondsToScale(commentData.time))
			}

			Binding on x { value: line.getPosition() }
			Connections {
				target: context.timelineController
				ignoreUnknownSignals: false
				onScaleChanged: line.x = line.getPosition()
			}
		}
	}
}
