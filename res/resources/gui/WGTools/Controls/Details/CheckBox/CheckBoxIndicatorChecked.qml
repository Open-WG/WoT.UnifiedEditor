import QtQuick 2.11

Image {
	width: parent.width
	height: parent.height
	cache: false
	source: "image://gui/icon-check?color=" + encodeURIComponent(control.icon.color)
}
