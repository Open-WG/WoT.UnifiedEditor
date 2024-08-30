import QtQuick 2.7

Rectangle {
	id: root

	property Item buddy
	property alias shown: shownState.when

	property real shownOpacity: 0.5
	property real shownWidthFactor: 0.9

	property real delay: 0
	property real duration: 500

	property real _currWidthFactor: 0.5

	width: buddy ? buddy.width * _currWidthFactor : undefined;
	height: 1
	color: (buddy && typeof buddy.color != "undefined") ? buddy.color : _palette.color3
	opacity: 0

	states: State {
		id: shownState

		PropertyChanges {
			target: root
			opacity: root.shownOpacity
			_currWidthFactor: root.shownWidthFactor
		}
	}

	transitions: Transition {
		SequentialAnimation {
			PauseAnimation { duration: root.delay }
			ParallelAnimation {
				NumberAnimation { property: "opacity"; duration: root.duration; easing.type: Easing.OutCubic }
				NumberAnimation { property: "_currWidthFactor"; duration: root.duration; easing.type: Easing.OutBack }
			}
		}
	}

	anchors.top: buddy ? buddy.bottom : undefined
	anchors.horizontalCenter: buddy ? buddy.horizontalCenter : undefined
}