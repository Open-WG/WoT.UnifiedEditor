import QtQuick 2.10

Item {
	Image {
		x: 0
		anchors.verticalCenter: parent.verticalCenter
		source: "image://gui/no-image"

		Image {
			x: 14
			y: 11
			source: "image://gui/warning"
		}
	}
}