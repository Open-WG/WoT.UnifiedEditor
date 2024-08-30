import QtQuick 2.10

Item {
	width: control.width
	height: control.height

	Rectangle {
		width: 5
		height: parent.height
		color: control.activeFocus ? _palette.color13 : _palette.color12
		visible: control.selected
	}
}
