import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0 as Controls

RowLayout {
	spacing: 5

	Controls.Button {
		Layout.preferredWidth: 80
		Layout.preferredHeight: 24

		enabled: context.filesystemController.canOperateLocks

		text: "Lock"

		onClicked: context.filesystemController.lock()
	}

	Controls.Button {
		Layout.preferredWidth: 80
		Layout.preferredHeight: 24

		enabled: context.filesystemController.canOperateLocks

		text: "Unlock"

		onClicked: context.filesystemController.unlock()
	}

	Controls.Button {
		Layout.preferredWidth: 80
		Layout.preferredHeight: 24

		text: "Commit"

		onClicked: context.filesystemController.commit()
	}

	Controls.Button {
		Layout.preferredWidth: 95
		Layout.preferredHeight: 24

		text: "Commit Space"

		onClicked: context.filesystemController.commitSpace()
	}

	Controls.Button {
		Layout.preferredWidth: 80
		Layout.preferredHeight: 24

		text: "Update"

		onClicked: context.filesystemController.update()
	}

	Controls.Button {
		Layout.preferredWidth: 80
		Layout.preferredHeight: 24
		
		text: "Check Locks"
		onClicked: context.filesystemController.updateStatus()
	}
}
