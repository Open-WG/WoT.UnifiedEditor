import QtQuick 2.11

Rectangle {
	implicitWidth: 256
	implicitHeight: 256
	color: _palette.color8

	Image {
		id: image
		anchors {
			fill: parent
			margins: 1
		}
		
		fillMode: Image.PreserveAspectFit
		verticalAlignment: Image.AlignVCenter
		horizontalAlignment: Image.AlignHCenter
		source: context.imagePath != "" ? "image://unifiedImageProvider/" + context.imagePath + "?imageIndex=0&R=1&G=1&B=1&A=0" : "image://gui/no-image"
		cache: false
		asynchronous: true
		smooth: true
	}
}