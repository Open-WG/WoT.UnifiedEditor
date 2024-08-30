import QtQuick 2.11
import QtQuick.Layouts 1.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

Button {
	focusPolicy: Qt.StrongFocus
	flat: true

	Layout.alignment: Qt.AlignVCenter

	ToolTip.visible: hovered
	ToolTip.delay: ControlsSettings.tooltipDelay
	ToolTip.timeout: ControlsSettings.tooltipTimeout
}
