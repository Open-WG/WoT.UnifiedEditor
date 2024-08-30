import QtQuick 2.10
import QtQuick.Dialogs 1.2
import WGTools.Resources 1.0 as WGTResources
import WGTools.Dialogs 1.0 as Dialogs

Item {
	signal pathAccepted(string filePath, string folderPath)

	property alias window: mainDialog
	property string initialFolder: ""
	property string selectedFile: ""
	property bool anyDir: false

	Dialogs.FileDialog {
		id: mainDialog

		onVisibleChanged: {
			if (visible) {
				if (!anyDir && !WGTResources.Resources.isCurrentBranch(initialFolder)) {
					folder = WGTResources.Resources.fileNameToUrl(WGTResources.Resources.getCurrentBranch())
				} else {
					folder = WGTResources.Resources.fileNameToUrl(initialFolder)
				}

				if (selectedFile.length != 0)
					fileUrl = WGTResources.Resources.fileNameToUrl(selectedFile)
			}
		}

		onAccepted: {
			var filePath = WGTResources.Resources.fileNameFromUrl(fileUrl)
			var folderPath = WGTResources.Resources.getFilePath(filePath)

			if (anyDir || checkBranch.check(folderPath)) {
				pathAccepted(filePath, folderPath)
			}
		}
	}

	CheckBranchDialog {
		id: checkBranch

		onFinished: {
			mainDialog.open()
		}
	}
}
