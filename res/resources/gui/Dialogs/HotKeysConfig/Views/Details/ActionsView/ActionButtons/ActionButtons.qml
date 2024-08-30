import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.ControlsEx.ActionViews 1.0

ActionsRow {
	delegate: ActionButton {}
	spacing: ControlsSettings.spacing

	Action {
		enabled: model.shortcut && !control.editing && (control.highlighted || (control.hovered && !view.flicking))
		text: "Delete shortcut"
		icon.source: "image://gui/icon-remove"

		onTriggered: {
			model.shortcut = ""
		}
	}

	Action {
		enabled: !model.shortcutDefault && !control.editing
		text: "Revert shortcut to default"
		icon.source: "image://gui/enter"

		onTriggered: {
			view.model.resetActionShortcut(index)
		}
	}
}
