import WGTools.Controls.Details 2.0
import WGTools.Resources 1.0 as WGTResources
import "../Common" as Common

ComboBoxPopupContent {
	header: ComboBoxDelegate {
		property var index: -1
		highlighted: hovered
		hoverEnabled: true
		text: "Choose File..."
		icon.source: "image://gui/icon-folder"
		onHoveredChanged: control.highlightEnabled = !hovered

		property string rootResourcePath: "content/"
		property string resourceType: ""		// "texture", "shader", etc.

		function openFileDialog() {
			if (propertyData.value != undefined && WGTResources.Resources.fileExists(propertyData.value)) {
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
}
