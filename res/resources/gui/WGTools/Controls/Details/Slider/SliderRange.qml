import QtQuick 2.11
import WGTools.Controls.Details 2.0

Rectangle {
	implicitWidth: ControlsSettings.thickStrokeWidth
	implicitHeight: ControlsSettings.thickStrokeWidth
	color: control.enabled ? _palette.color12 : _palette.color5
	
	ColorBehavior on color {}
}
