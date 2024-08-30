import QtQuick 2.7

Item {
	id: lodbar

	property var model: null
	property real range: 0
	property bool readOnly: false

	Accessible.name: "Lod bar"

	implicitWidth: background.implicitWidth
	implicitHeight: background.implicitHeight

	LodBarBackground {
		id: background
		anchors.fill: parent
	}

	LodBarContent {
		id: contentItem
		anchors.fill: parent
	}
}
