import QtQuick 2.11
import QtQml.StateMachine 1.0 as SM
import WGTools.Controls 2.0
import "Transitions"
import "States"

Item {
	id: root

	property alias text: label.text
	property alias duration: durationLine.implicitWidth

	property real animDuration: 500

	property bool hovered: false
	property bool compact: false
	readonly property bool compactOnly: text.length == 0

	implicitWidth: background.implicitWidth
	implicitHeight: background.implicitWidth

	CommentBackground {
		id: background
		implicitWidth: label.implicitWidth + 20
		width: implicitWidth
	}

	CommentHoverIndicator {
		id: hoverIndicator
		hovered: root.hovered
		anchors.fill: background
	}

	CommentMarker {
		id: marker
	}

	Item {
		clip: true
		anchors.fill: background

		Label {
			id: label
			x: parent.x + (parent.width - width) / 2
			y: parent.y + (parent.height - height) / 2
		}
	}

	CommentDurationLine {
		id: durationLine
		hovered: root.hovered
	}

	SM.StateMachine {
		initialState: root.compact ? comactState : normalState
		running: true

		SM.State {
			id: normalState
			onEntered: root.state = ""

			SM.SignalTransition { targetState: comactState; signal: root.compactChanged; guard: root.compact }
			SM.SignalTransition { targetState: comactState; signal: root.compactOnlyChanged; guard: root.compactOnly }
		}

		SM.State {
			id: comactState
			onEntered: root.state = "compact"

			SM.SignalTransition { targetState: normalState; signal: root.compactChanged; guard: !root.compact && !root.compactOnly }
			SM.SignalTransition { targetState: normalState; signal: root.compactOnlyChanged; guard: !root.compact && !root.hovered && !root.compactOnly }
			SM.SignalTransition { targetState: hoveredState; signal: root.hoveredChanged; guard: root.hovered && !root.compactOnly }
			SM.SignalTransition { targetState: hoveredState; signal: root.compactOnlyChanged; guard: root.hovered && !root.compactOnly }
		}

		SM.State {
			id: hoveredState
			onEntered: root.state = ""

			SM.SignalTransition { targetState: normalState; signal: root.compactChanged; guard: !root.compact }
			SM.SignalTransition { targetState: comactState; signal: root.hoveredChanged; guard: !root.hovered }
		}
	}

	state: compact || compactOnly ? "compact" : ""
	states: [
		CommentsStateCompact { name: "compact" }
	]

	transitions: [
		Transition { from: ""; CommentTransitionFromNormal {} },
		Transition { to: ""; CommentTransitionToNormal {} }
	]
}
