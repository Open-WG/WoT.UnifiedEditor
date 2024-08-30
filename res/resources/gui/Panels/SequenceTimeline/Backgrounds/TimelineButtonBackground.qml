import QtQuick 2.7

import "..//Constants.js" as Constants

Rectangle {
	id: buttonBackground

	property bool borderVisible: false
	property alias borderRadius: buttonBackground.radius

	color: enabled ? Constants.defaultButtonColor : Constants.defaultButtonDisabledColor
	radius: 3

	border.color: borderVisible ? "black" : "transparent"
	border.width: 0

	Rectangle {
		id: addColorLayer

		visible: buttonBackground.parent.hovered || buttonBackground.parent.pressed

		anchors.fill: parent
		anchors.margins: parent.border.width

		radius: parent.radius

		color: getColor()

		function getColor() {
			if (buttonBackground.parent.pressed) {
				return Constants.defaultButtonPressedColor
			}
			else {
				return Constants.defaultButtonHoveredColor
			}
		}
	}
}
