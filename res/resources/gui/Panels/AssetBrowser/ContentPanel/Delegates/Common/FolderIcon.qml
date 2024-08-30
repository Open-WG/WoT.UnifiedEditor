import QtQuick 2.7

Item {
	property alias source: img.source

	implicitWidth: img.implicitWidth
	implicitHeight: img.implicitHeight

	Image {
		id: img
		source: "image://gui/preview-folder"
		sourceSize.width: parent.width
		anchors.centerIn: parent
	}
}
