import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0 as Details

ToolButton {
	Accessible.name: ToolTip.text

	icon.width: ControlsSettings.iconSize
	icon.height: ControlsSettings.iconSize
	implicitWidth: icon.width + leftPadding + rightPadding
	implicitHeight: icon.height + topPadding + bottomPadding

	iconicStyle: model.action.hasCheckedIcon
	checkable: model.action.checkable
	enabled: model.action.enabled
	icon.source: model.action.icon ? "image://gui/" + model.action.icon : ""
	ToolTip.text: model.action.text

	onClicked: {
		model.action.execute()
	}

	Binding on checked {
		value: model.action.checked
	}
}
