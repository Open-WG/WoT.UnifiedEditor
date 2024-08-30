import QtQuick 2.7
import "../../../Settings.js" as Settings

FocusScope {
	id: contentItem

	property bool editing: false;

	width: control.width - control.padding*2;
	height: control.height - control.padding*2;
	x: control.padding
	y: control.padding

	StateView {
		opacity: 1 - editState.opacity
		focus: !editState.focus
	}

	StateEdit {
		id: editState
		opacity: 0
		focus: false
		onFinishEditing: contentItem.editing = false
	}

	states: State {
		name: "edit"
		when: contentItem.editing

		PropertyChanges { target: editState; opacity: 1; focus: true }
	}

	transitions: [
		Transition {
			to: "edit"

			SequentialAnimation {
				PropertyAction { target: editState; property: "focus" }
				NumberAnimation { target: editState; property: "opacity"; duration: Settings.interactionAnimDuration; easing.type: Easing.OutCubic; }
			}
		},

		Transition {
			from: "edit"

			SequentialAnimation {
				NumberAnimation { target: editState; property: "opacity"; duration: Settings.interactionAnimDuration; easing.type: Easing.OutCubic; }
				PropertyAction { target: editState; property: "focus" }
			}
		}
	]
}
