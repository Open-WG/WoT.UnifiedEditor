import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0 as Details
import WGTools.Resources 1.0 as WGTResources
import "../Common" as Common

Details.BasicIndicatorButton {
	id: button

	property string rootResourcePath: "content/"
	property string resourceType: ""		// "texture", "shader", etc.

	text: propertyData ? propertyData.button.text : ""
	source: "controls-folder"

	Accessible.name: propertyData ? propertyData.button.text : "Open"

	ToolTip.text: propertyData ? propertyData.button.tooltip : ""
	ToolTip.delay: ControlsSettings.tooltipDelay
	ToolTip.timeout: ControlsSettings.tooltipTimeout
	ToolTip.visible: ToolTip.text && hovered

	function openFileDialog() {
		if (propertyData.value != undefined && WGTResources.Resources.fileExists(propertyData.value) &&
				!(resourceType == "texture" && propertyData.value == "helpers/aid_builder.dds")) {
			dialog.initialFolder = WGTResources.Resources.getFilePath(propertyData.value)
			dialog.selectedFile = propertyData.value
		} else if (dialog.initialPath) {
			dialog.initialFolder = dialog.initialPath // can be optimised
		} else {
			var lastFileDialogPath = WGTResources.Resources.lastFileDialogPath(resourceType)
			dialog.initialFolder = lastFileDialogPath ? lastFileDialogPath : rootResourcePath
		}

		dialog.window.open()
	}

	onClicked: {
		openFileDialog();
	}

	Common.PropertyPathDialog
	{
		id: dialog
		pathPropertyData: propertyData
	}
}
