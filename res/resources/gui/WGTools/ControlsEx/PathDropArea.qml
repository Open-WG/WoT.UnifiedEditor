import QtQuick 2.7
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Resources 1.0 as WGTResources

DropArea {
	id: control

	anchors.fill: parent

	property var target
	property var propertyData

	onEntered: {
		drag.accepted =
			drag.urls.length == 1 &&
			checkExtension(drag.urls[0].split('.').pop())
	}

	onDropped: {
		propertyData.setValue(WGTResources.Resources.fileNameFromUrl(drop.urls[0]))
	}

	function checkExtension(ext) {
		if (!propertyData) {
			return true
		}
		var list = propertyData.dialog.filters
		for (var i = 0; i < list.length; ++i) {
			if (ext == list[i].split('.').pop()) {
				return true
			}
		}
		return false
	}

	DropIndicator {
		containsDrag: control.containsDrag
		anchors.fill: parent
	}
}
