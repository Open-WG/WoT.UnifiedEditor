import QtQuick 2.10

Rectangle {
	id: root
	color: "black"
	anchors.fill: parent

	AnimatedImage {
		id: image

		// TODO: animated image doesn't work with our image provider
		//reset source if root is invisible, because for huge atlases it lags
		source: root.visible ? "../../../images/load.gif" : ""

		width: root.width
		height: root.width
		fillMode: Image.Pad
		asynchronous: true
		cache: false
	}
}
