import QtQuick 2.11

Item {
	Repeater {
		model: context.globalComments

		TimelineGlobalCommentLine {
			id: line
			height: parent.height

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
