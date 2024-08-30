import QtQuick 2.11

ParallelAnimation {
	// duration line
	SequentialAnimation {
		PropertyAction { target: durationLine; property: "visible" }
		NumberAnimation { target: durationLine; property: "width"; duration: root.animDuration; easing.type: Easing.OutBack }
	}

	// background
	SequentialAnimation {
		PropertyAction { target: background; property: "visible" }
		ParallelAnimation {
			NumberAnimation { target: background; property: "width"; duration: root.animDuration; easing.type: Easing.OutCubic }
			NumberAnimation { target: background; property: "opacity"; duration: root.animDuration; easing.type: Easing.OutCubic }
		}
	}

	// label
	SequentialAnimation {
		PropertyAction  { target: label; property: "visible" }
		ParallelAnimation {
			NumberAnimation { target: label; property: "x"; duration: root.animDuration; easing.type: Easing.OutCubic }
			NumberAnimation { target: label; property: "opacity"; duration: root.animDuration; easing.type: Easing.OutCubic }
		}
	}
}
