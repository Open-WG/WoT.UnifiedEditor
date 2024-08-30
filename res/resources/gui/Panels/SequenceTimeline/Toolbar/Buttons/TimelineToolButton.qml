import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.Buttons 1.0

ToolButton {
	id: button
	iconImageSize.width: Constants.playbackIconWidth
	iconImageSize.height: Constants.playbackIconHeight

	Accessible.name: button.ToolTip.text

	ToolTip.text: text
	ToolTip.visible: hovered
	ToolTip.delay: ControlsSettings.tooltipDelay
	ToolTip.timeout: ControlsSettings.tooltipTimeout
}
