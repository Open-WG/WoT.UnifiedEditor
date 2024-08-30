import QtQuick 2.7

Rectangle {
	color: model.checked ? model.iconColour : "transparent"

	border.width: model.checked ? 0 : 2
	border.color: model.iconColour

	anchors.fill: parent
	anchors.centerIn: parent
}