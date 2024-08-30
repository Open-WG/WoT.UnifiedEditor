import QtQuick 2.11
import WGTools.Misc 1.0 as Misc
import Panels.SequenceTimeline.Comments 1.0
import Panels.SequenceTimeline.Menus 1.0

MouseArea {
	id: container
	implicitHeight: 18
	acceptedButtons: Qt.LeftButton | Qt.RightButton
	visible: context.sequenceOpened
	clip: true

	// comments
	Repeater {
		model: context.globalComments
		
		Comment {
			timelineViewID: sequenceTree.timelineViewID
			global: true

			onHoveredChanged: {
				commentsCommonData.hoveredGlobalCommentIndex = hovered ? index : -1
			}
		}
	}

	onDoubleClicked: if (mouse.button == Qt.LeftButton) {
		var frames = context.timelineController.fromScreenToScaleClipped(mouse.x)
		var time = context.timelineController.fromFramesToSeconds(frames)
		context.commentsDialogController.addGlobalComment(time)
	}

	// context menu
	Misc.MenuLoader {
		id: menuLoader
		property var itemTime
		menuComponent: ContextMenuCommentsGlobal {}
		onLoaded: {
			item.time = itemTime
		}

		Connections {
			target: container
			onClicked: if (mouse.button == Qt.RightButton) {
				var frames = context.timelineController.fromScreenToScaleClipped(mouse.x)
				menuLoader.itemTime = context.timelineController.fromFramesToSeconds(frames)
				menuLoader.popup()
			}
		}
	}
}
