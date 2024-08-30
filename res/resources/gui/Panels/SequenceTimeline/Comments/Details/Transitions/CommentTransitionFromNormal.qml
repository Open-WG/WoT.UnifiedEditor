import QtQuick 2.11

ParallelAnimation {
	// duration line
	SequentialAnimation {
		NumberAnimation { target: durationLine; property: "width"; duration: root.animDuration; easing.type: Easing.InBack }
		PropertyAction { target: durationLine; property: "visible" }
	}

	SequentialAnimation {
		PauseAnimation { duration: root.animDuration * 3/4}
		ParallelAnimation {
			// background
			SequentialAnimation {
				ParallelAnimation {
					NumberAnimation { target: background; property: "width"; duration: root.animDuration; easing.type: Easing.OutQuint }
					NumberAnimation { target: background; property: "opacity"; duration: root.animDuration; easing.type: Easing.InCubic }
				}
				PropertyAction { target: background; property: "visible" }
			}

			// label
			SequentialAnimation {
				ParallelAnimation {
					NumberAnimation { target: label; property: "x"; duration: root.animDuration; easing.type: Easing.OutQuint }
					NumberAnimation { target: label; property: "opacity"; duration: root.animDuration; easing.type: Easing.InCubic }
				}
				PropertyAction  { target: label; property: "visible" }
			}
		}
	}
}
