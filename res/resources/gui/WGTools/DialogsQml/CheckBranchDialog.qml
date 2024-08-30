import QtQuick 2.10
import QtQuick.Dialogs 1.3
import WGTools.Resources 1.0 as WGTResources

Item {
	id: root

	signal finished()

	function check(path) {
		if (WGTResources.Resources.isCurrentBranch(path)) {
			return true
		}

		dialog.open()
		return false
	}

	MessageDialog {
		id: dialog

		title: "Unable to resolve file path"
		text: "You can select a file located only in one of the resource folders"
		icon: StandardIcon.Warning
		modality: Qt.ApplicationModal
		standardButtons: StandardButton.Ok

		onAccepted: {
			root.finished()
		}

		onRejected: {
			root.finished()	
		}
	}
}
