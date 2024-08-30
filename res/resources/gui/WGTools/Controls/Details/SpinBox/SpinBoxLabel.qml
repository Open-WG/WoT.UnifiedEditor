import QtQuick 2.11

Text {
	x: control.leftPadding
	y: control.topPadding
	height: control.availableHeight
		
	horizontalAlignment: TextInput.AlignLeft
	verticalAlignment: TextInput.AlignVCenter
	
	color: _palette.color2
	visible: text != ""

	font: control.font
}