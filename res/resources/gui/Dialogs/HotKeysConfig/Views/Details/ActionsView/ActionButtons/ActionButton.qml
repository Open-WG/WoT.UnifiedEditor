import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

Button {
	id: control
	action: modelData
	flat: true
	opacity: enabled ? 1 : 0

	icon.color: _palette.color1
	icon.width: ControlsSettings.iconSize
	icon.height: ControlsSettings.iconSize

	ToolTip.text: action ? action.text : ""
	ToolTip.visible: hovered
	ToolTip.delay: ControlsSettings.tooltipDelay
	ToolTip.timeout: ControlsSettings.tooltipTimeout
}
