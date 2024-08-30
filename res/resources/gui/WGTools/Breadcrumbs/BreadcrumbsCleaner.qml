import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

Button {
	icon.source: "image://gui/icon-delete"

	ToolTip.text: "Remove all quick filters"
	ToolTip.visible: hovered
	ToolTip.delay: ControlsSettings.tooltipDelay
	ToolTip.timeout: ControlsSettings.tooltipTimeout
}
