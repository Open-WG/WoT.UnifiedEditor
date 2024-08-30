import QtQuick 2.11
import WGTools.Controls.Details 2.0

TextFieldSeparator {
	x: control.width
		- control.padding
		- (control.buttonsVisible ? (control.__buttonsWidth + control.spacing + width) : 0)
	opacity: control.buttonsVisible
	visible: opacity

	NumberBehavior on opacity {}
	NumberBehavior on x {}
}