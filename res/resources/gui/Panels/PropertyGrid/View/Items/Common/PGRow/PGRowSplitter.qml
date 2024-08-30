import QtQuick 2.11

MouseArea {
	id: splitter

	property PGRowSplitterData sharedData: null

	width: control.spacing
	height: control.height
	hoverEnabled: true
	preventStealing: true
	cursorShape: enabled ? Qt.SizeHorCursor : Qt.ArrowCursor
	visible: control.horizontal && control.label && control.label.enabled
	x: drag.minimumX

	drag.target: splitter
	drag.axis: Drag.XAxis
	drag.minimumX: control.leftPadding
	drag.maximumX: control.leftPadding + control.availableWidth - width
	drag.threshold: 0

	onXChanged: {
		if (drag.active && sharedData) {
			sharedData.autoPosition = false
			sharedData.x = x
		}
	}

	onDoubleClicked: {
		if(mouse.button == Qt.LeftButton) {
			sharedData.autoPosition = true
		}
	}

	Binding on x {
		value: splitter.sharedData ? splitter.sharedData.x : splitter.x
		when: splitter.sharedData && !splitter.drag.active
	}

	Binding {
		target: splitter.sharedData
		property: "hovered"
		value: true
		when: splitter.sharedData && splitter.containsMouse
	}

	Binding {
		target: splitter.sharedData
		property: "pressed"
		value: true
		when: splitter.sharedData && (splitter.containsPress || splitter.pressed)
	}
}
