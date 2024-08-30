import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details

T.Label {
	id: control
	color: _palette.color1
	linkColor: _palette.color11

	font.family: ControlsSettings.fontFamily
	font.pixelSize: ControlsSettings.textNormalSize
	font.hintingPreference: Font.PreferFullHinting

	Details.ColorBehavior on color {}
}
