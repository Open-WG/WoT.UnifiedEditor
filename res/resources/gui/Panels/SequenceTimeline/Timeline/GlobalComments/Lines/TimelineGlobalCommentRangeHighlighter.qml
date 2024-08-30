import QtQuick 2.11

Rectangle {
	id: range
	opacity: 0

	function getWidth() {
		if (commentData.duration == 0) {
			return 0
		}
		return Math.round(context.timelineController.fromSecondsToScale(commentData.duration) -
			context.timelineController.fromSecondsToScale(0))
	}
	
	Binding on width { value: rangeHighlighter.getWidth() }

	states: State {
		when: commentsCommonData.hoveredGlobalCommentIndex == index
		PropertyChanges { target: range; opacity: 0.1 }
	}

	transitions: Transition {
		NumberAnimation { target: range; property: "opacity"; duration: 500; easing.type: Easing.OutCubic }
	}

	Connections {
		target: context.timelineController
		onScaleChanged: width = rangeHighlighter.getWidth()
	}
}
