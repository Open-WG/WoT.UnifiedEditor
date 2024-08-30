import QtQuick 2.7

MouseArea {
	width: parent.width
	height: parent.height
	hoverEnabled: true

	Rectangle {
		width: control.width
		height: control.height
		color: (model != undefined) ? _palette[model.lod.name] : "#FFF"
	}
}
