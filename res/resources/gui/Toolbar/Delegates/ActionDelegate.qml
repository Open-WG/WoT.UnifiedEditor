import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.impl 1.0

ToolButton {
	action: adapter
	iconicStyle: adapter.multiicon
	text: ""
	icon.source: action.icon.source // due to icon resolving in QQuickAbstractButtonPrivate::updateEffectiveIcon
	ToolTip.text: action.text
	Accessible.name: action.text

	ActionAdapter {
		id: adapter
		action: model.action
		sourceScheme: "image://gui/"
	}
}
