import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

Button {
	id: control
	text: model.display
	checkable: true
	
	icon.source: model.decoration
	icon.color: "transparent"

	ToolTip.text: model.toolTip
	ToolTip.visible: hovered && ToolTip.text.length > 0
	ToolTip.delay: ControlsSettings.tooltipDelay
	ToolTip.timeout: ControlsSettings.tooltipTimeout
}
