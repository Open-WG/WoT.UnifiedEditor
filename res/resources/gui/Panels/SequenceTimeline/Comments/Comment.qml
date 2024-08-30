import QtQuick 2.11
import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.Menus 1.0
import WGTools.Misc 1.0 as Misc
import WGTools.QmlUtils 1.0
import "Details"

Item {
	id: comment

	property var timelineViewID
	property bool global: false
	readonly property alias hovered: ui.hovered

	z: hovered ? 100000 : commentData.time

	// helpers
	function getPointsFromGlobalSeconds(time) {
		return context.timelineController.fromSecondsToScale(time) - context.timelineController.fromSecondsToScale(commentData.minTime) * !global
	}

	function getGlobalTime() {
		var ui = parent.mapToItem(timelineViewID, x, y)
		var frame = context.timelineController.fromScreenToScaleClipped(ui.x)
		return context.timelineController.fromFramesToSeconds(frame)
	}

	// position calculation
	function getPosition() { return getPointsFromGlobalSeconds(commentData.time) }

	Binding on x { value: getPosition() }
	Connections {
		target: context.timelineController
		ignoreUnknownSignals: false
		onScaleChanged: comment.x = comment.getPosition()
	}

	// ui
	CommentUI {
		id: ui
		text: commentData.text
		compact: commentData.compact
		hovered: mouseArea.containsMouse || mouseArea.drag.active
		visible: commentData.time < commentData.maxTime || MathUtils.almostEqual(commentData.time, commentData.maxTime)
		enabled: visible

		// duration calculation
		function getDuration() {
			if (commentData.duration == 0) {
				return 0
			}
			
			return context.timelineController.fromSecondsToScale(commentData.duration) - context.timelineController.fromSecondsToScale(0)
		}

		Binding on duration { value: ui.getDuration() }
		Connections {
			target: context.timelineController
			onScaleChanged: ui.duration = ui.getDuration()
		}

		// compact toggling
		Connections {
			target: mouseArea
			onDoubleClicked: if (mouse.button == Qt.LeftButton) {
				commentData.compact = !commentData.compact
			}
		}
	}

	// interaction
	MouseArea {
		id: mouseArea
		hoverEnabled: true
		acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

		anchors.fill: ui
		drag.target: comment
		drag.axis: Drag.XAxis

		// limits culculations
		function calculateMinTime() { return getPointsFromGlobalSeconds(commentData.minTime) }
		function calculateMaxTime() { return getPointsFromGlobalSeconds(commentData.maxTime) }

		Binding on drag.minimumX { value: mouseArea.calculateMinTime() }
		Binding on drag.maximumX { value: mouseArea.calculateMaxTime() }
		Connections {
			target: context.timelineController
			onScaleChanged: {
				mouseArea.drag.minimumX = mouseArea.calculateMinTime()
				mouseArea.drag.maximumX = mouseArea.calculateMaxTime()
			}
		}

		// time modifications
		Connections {
			enabled: mouseArea.drag.active
			target: comment
			onXChanged: commentData.time = comment.getGlobalTime()
		}

		Connections {
			enabled: !mouseArea.drag.active
			target: mouseArea.drag
			onActiveChanged: commentData.commitTime()
		}
	}

	// context menu
	Misc.MenuLoader {
		id: menuLoader
		menuComponent: ContextMenuComment {}
		
		Connections {
			target: mouseArea
			onClicked: switch (mouse.button) {
				case Qt.RightButton:
					menuLoader.popup()
					break
				case Qt.MiddleButton:
					context.commentsDialogController.changeComment(commentData)
					break
			}
		}
	}
}
