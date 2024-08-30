import QtQuick 2.7

Image {
	source: (model && model.decoration != "") ? "image://gui/" + model.decoration : ""
	// scale: buttonHolder.styleData.selected
	// 	? 1.25
	// 	: 1.0

	anchors.centerIn: parent

	// Behavior on scale {
	// 	NumberAnimation { duration: 500; easing.type: Easing.OutCubic}
	// }
}