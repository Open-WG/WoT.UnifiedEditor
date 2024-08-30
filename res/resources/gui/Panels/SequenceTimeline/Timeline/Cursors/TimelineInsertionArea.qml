import QtQuick 2.11

MouseArea {
	id: insertArea
	focus: context.insertingNodes
	enabled: context.insertingNodes
	visible: enabled
	hoverEnabled: true
	clip: true

	onReleased: {
		context.insertingNodes = false

		var frame = context.timelineController.fromScreenToScaleClipped(mouse.x)
		var newVal = context.timelineController.fromFramesToSeconds(frame)

		context.pasteCopiedNodesFromTheBuffer(newVal)
	}

	TimelineInsertionCursor {
		x: insertArea.mouseX
	}

	// Ensure that we get escape key press events first.
	Keys.onShortcutOverride: event.accepted = (event.key === Qt.Key_Escape)
	Keys.onEscapePressed: {
		context.insertingNodes = false
		event.accepted = true
	}
}
