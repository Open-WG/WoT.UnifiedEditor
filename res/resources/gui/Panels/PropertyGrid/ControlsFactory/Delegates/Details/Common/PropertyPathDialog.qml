import QtQuick 2.11
import QtQuick.Dialogs 1.2
import WGTools.PropertyGrid 1.0 as PG
import QtQuick.Dialogs 1.3 as QtQuickDialogs
import WGTools.Resources 1.0 as WGTResources
import WGTools.DialogsQml 1.0 as Dialogs


Dialogs.FileDialog {
	property var pathPropertyData
	property string initialPath: pathPropertyData ? pathPropertyData.dialog.initialPath : ""

	anyDir: pathPropertyData ? pathPropertyData.dialog.anyDir: false

	window.title: pathPropertyData ? pathPropertyData.dialog.title : ""
	window.nameFilters: pathPropertyData ? pathPropertyData.dialog.filters : []
	window.selectExisting: pathPropertyData ? pathPropertyData.dialog.selectExisting : true
	window.selectFolder: pathPropertyData ? pathPropertyData.dialog.selectFolder : false
	window.anyDir: anyDir

	PG.PropertyValueVerifier {
		id: verifier
		propertyData: pathPropertyData
		value: undefined
		enabled: false
	}

	QtQuickDialogs.MessageDialog {
		id: messageDialog
		title: "Invalid Path"
		text: verifier.error
		icon: QtQuickDialogs.StandardIcon.Critical
		modality: Qt.WindowModal
	}

	onPathAccepted: {
		WGTResources.Resources.setLastFileDialogPath(resourceType, folderPath)
		verifier.value = filePath
		verifier.enabled = true
		if (verifier.valid)
		{
			pathPropertyData.setValue(filePath, PG.IValueData.IGNORE_VALIDATOR)  // already validated
		}
		else
		{
			messageDialog.open()
		}
		verifier.enabled = false
		verifier.value = undefined
	}
}
