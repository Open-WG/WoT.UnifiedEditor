import QtQuick 2.11

CommentBackground {
	id: root

	property bool hovered: false

	color: _palette.color12
	opacity: 0

	states: State {
		when: root.hovered

		PropertyChanges {
			target: root
			opacity: 0.8
		}
	}

	transitions: Transition {
		NumberAnimation { target: root; property: "opacity"; duration: 500; easing.type: Easing.OutCubic }
	}
}
