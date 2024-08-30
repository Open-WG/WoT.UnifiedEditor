import QtQuick 2.7
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Resources 1.0 as WGTResources

DropArea {
	id: control

	keys: [ "text/uri-list", "text/plain" ]
	anchors.fill: parent

	property var target
	property var propertyData

	onEntered: {
		hoverIndicator.visible = true
	}

	onExited: {
		hoverIndicator.visible = false
	}

	onDropped: {
		hoverIndicator.visible = false
		if (drop.urls.length == 1) {
			if (checkExtension(drop.urls[0].split('.').pop())) {
				propertyData.setValue(WGTResources.Resources.fileNameFromUrl(drop.urls[0]))
			} else {
				target.ToolTip.text = "This extension is not supported. Supported extensions: " + propertyData.dialog.filters
				target.ToolTip.visible = true
			}
		} else {
			target.ToolTip.text = "Multiple files drop is not supported"
			target.ToolTip.visible = true
		}
	}

	Rectangle {
		id: hoverIndicator

		visible: false
		anchors.fill: parent
		radius: ControlsSettings.radius
		border.width: 2
		border.color: _palette.color12
		color: Qt.rgba(_palette.color12.r, _palette.color12.g, _palette.color12.b, 0.3)
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
}