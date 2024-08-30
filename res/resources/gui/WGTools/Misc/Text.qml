import QtQuick 2.7
import WGTools.Controls.Details 2.0

Text {
	property string size: "Normal"

	color: _palette.color1

	font.family: ControlsSettings.fontFamily
	font.pixelSize: ControlsSettings["text" + size + "Size"]
}
