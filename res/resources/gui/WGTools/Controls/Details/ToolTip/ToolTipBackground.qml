import QtQuick 2.11
import WGTools.Controls.Details 2.0

PopupBackground {
	implicitHeight: ControlsSettings.height
	color: _palette.color1
	border.width: 0

	ToolTipArrowLoader {
		sourceComponent: ToolTipArrow {}
	}
}
