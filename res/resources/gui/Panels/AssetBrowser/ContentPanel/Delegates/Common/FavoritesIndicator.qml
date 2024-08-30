import QtQuick 2.7

Item {
	property bool value: true
	property color color

	implicitWidth: image.implicitWidth
	implicitHeight: image.implicitHeight
	opacity: value ? 1 : 0

	Behavior on opacity {
		NumberAnimation { duration: 100 }
	}

	Image {
		id: image
		source: "image://gui/icon-content-favorite" + ((parent.color != undefined) ? ("?color=" + encodeURIComponent(parent.color)) : "")
		smooth: false

		anchors.fill: parent
	}
}
