import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Dialogs 1.0 as Dialogs

T.Button {
	id: control
	Accessible.name: "Preview"

	function closeDialog() {
		dialog.close()
	}

	onClicked: {
		dialog.activate(delegateRoot.rgb, delegateRoot.alphaChannel ? true : false)
	}

	Dialogs.ColorDialog {
		id: dialog
		title: delegateRoot.model ? delegateRoot.model.node.label.text : "Choose a color"

		onCurrentColorModified: delegateRoot.setHSB(currentColor, true)
		onFinished: {
			if (result) {
				delegateRoot.setHSB(currentColor, false)
			} else {
				delegateRoot.restore()
			}
		}
	}
}
