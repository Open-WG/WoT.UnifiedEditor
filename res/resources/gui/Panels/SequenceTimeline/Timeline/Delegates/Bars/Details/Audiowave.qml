import QtQuick 2.11

Image {
	property var color

	width: parent.width
	fillMode: Image.TileHorizontally
	horizontalAlignment: Image.AlignLeft
	source: "image://gui/animation_sequence/audiowave-pattern" + (color ? "?color=" + encodeURIComponent(color) : "")
	opacity: 0.2
}
