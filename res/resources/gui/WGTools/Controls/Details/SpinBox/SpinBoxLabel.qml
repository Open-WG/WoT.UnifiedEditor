import QtQuick 2.11

Text {
	property alias labelMouseArea: labelMouseArea
	property bool concatenate: false

	x: control.leftPadding
	y: control.topPadding
	z: 3
	height: control.availableHeight
		
	horizontalAlignment: TextInput.AlignLeft
	verticalAlignment: TextInput.AlignVCenter
	
	color: _palette.color2
	visible: text != ""

	font: control.font

	MouseArea {
		id: labelMouseArea
		anchors.fill: parent
		z: 4
	}
}