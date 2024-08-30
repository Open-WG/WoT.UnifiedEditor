import QtQuick 2.11
import QtQml.StateMachine 1.0 as DSM
import WGTools.Controls 2.0
import WGTools.Controls.impl 1.0
import "ActionButtons" as Details
import "ShortcutEdit" as Details
import "ShortcutView" as Details

ItemDelegate {
	id: control
	property alias editing: editState.active

	width: parent.width
	rightPadding: controls.width
	text: model.display
	highlighted: ListView.isCurrentItem
	focusPolicy: Qt.ClickFocus
	background: DelegateBackground {}
	onPressed: view.currentIndex = index

	icon.color: "transparent"
	icon.source: {
		if (!model.actionUniqueInBranch) {
			return "image://gui/not-valid"
		}

		if (!model.shortcutValid) {
			return "image://gui/warning"
		}

		if (!model.actionUnique) {
			return "image://gui/link?color=" + encodeURIComponent(_palette.color2)
		}

		return ""
	}

	// shortcut editing controls
	Row {
		id: controls
		x: control.width - control.spacing - width
		y: control.topPadding + (control.availableHeight - height) / 2
		spacing: 10

		Details.ShortcutEdit {
			id: shortcutEdit
			y: (parent.height - height) / 2
			text: control.ShortcutWriter.value
			visible: control.ShortcutWriter.enabled
		}

		Details.ShortcutView {
			id: shortcutView
			y: (parent.height - height) / 2
			shortcut: model.shortcut
			visible: !shortcutEdit.visible
		}

		Details.ActionButtons {
			y: (parent.height - height) / 2
		}
	}

	// editing logic
	DSM.StateMachine {
		initialState: viewState
		running: true

		DSM.State {
			id: viewState
			DSM.SignalTransition {targetState: editState; signal: control.doubleClicked}
			DSM.SignalTransition {targetState: editState; signal: control.Keys.enterPressed; guard: control.activeFocus}
			DSM.SignalTransition {targetState: editState; signal: control.Keys.returnPressed; guard: control.activeFocus}
		}

		DSM.State {
			id: editState
			onEntered: {
				control.ShortcutWriter.value = model.shortcut
				control.ShortcutWriter.enabled = true
			}
			onExited: {
				control.ShortcutWriter.enabled = false
			}

			DSM.SignalTransition {targetState: applyState; signal: control.ShortcutWriter.finished}
			DSM.SignalTransition {targetState: viewState; signal: control.ShortcutWriter.canceled}
			DSM.SignalTransition {targetState: viewState; signal: control.activeFocusChanged; guard: !control.activeFocus}
		}

		DSM.State {
			id: applyState
			onEntered: {
				model.shortcut = control.ShortcutWriter.value
			}

			DSM.TimeoutTransition {targetState: viewState; timeout: 0}
		}
	}
}
