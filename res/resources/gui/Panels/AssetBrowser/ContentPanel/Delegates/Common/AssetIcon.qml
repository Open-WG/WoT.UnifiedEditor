import QtQuick 2.7

Item {
	id: root
	property var source: null

	implicitWidth: img.implicitWidth
	implicitHeight: img.implicitHeight

	Image {
		id: img
		sourceSize.width: width
		sourceSize.height: height
		anchors.fill: parent
		cache: false
		source: root.source
	}

	Rectangle {
		color: "transparent"
		border.width: 1
		border.color: _palette.color5
		anchors.fill: parent
	}

	function reload() {
		img.source = ""
		img.source = Qt.binding(function() {
			return root.source;
		})
	}//function to refresh the source

}
