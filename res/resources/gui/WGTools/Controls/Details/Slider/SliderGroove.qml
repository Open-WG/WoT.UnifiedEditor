import QtQuick 2.11
import WGTools.Controls.Details 2.0

Rectangle {
	implicitWidth: ControlsSettings.thickStrokeWidth
	implicitHeight: ControlsSettings.thickStrokeWidth
	color: control.enabled ? _palette.color3 : _palette.color7
	
	ColorBehavior on color {}
}
