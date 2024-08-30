import QtQuick 2.10
import WGTools.Controls.Details 2.0 as Details

TextInput {
	id: control
	color: _palette.color2
	selectionColor: _palette.color12
	selectedTextColor: _palette.color1
	selectByMouse: true
	horizontalAlignment: TextInput.AlignLeft
	verticalAlignment: TextInput.AlignVCenter
	
	cursorDelegate: Details.CursorDelegate {
		textInput: control
	}

	font.family: ControlsSettings.fontFamily
	font.pixelSize: ControlsSettings.textNormalSize
}
