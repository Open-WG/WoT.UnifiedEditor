import QtQuick 2.7
import WGTools.Controls.Details 2.0

Item {
	property bool active
	signal activate()

	implicitWidth: 7
	implicitHeight: 7

	Rectangle {
		anchors.fill: parent

		color: active ? _palette.color12 : _palette.color7
		border.width: ControlsSettings.borderWidth
		border.color: active ? _palette.color12 : _palette.color3

		transform: Rotation { 
			origin.x: width / 2; 
			origin.y: height / 2; 
			angle: 45
		}
	}

	MouseArea {
		anchors.centerIn: parent
		implicitWidth: 15
		implicitHeight: 15

		onClicked: {
			activate()
		}
	}
}
