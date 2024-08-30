import QtQuick 2.11
import WGtools.Controls 2.0
import WGtools.Controls.Details 2.0

Button {
	id: control
	flat: true

	ToolTip.text: text
	ToolTip.delay: ControlsSettings.tooltipDelay
	ToolTip.timeout: ControlsSettings.tooltipTimeout
	ToolTip.visible: hovered
}
