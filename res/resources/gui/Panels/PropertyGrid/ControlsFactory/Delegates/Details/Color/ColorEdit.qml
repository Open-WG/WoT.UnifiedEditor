import QtQuick 2.7
import WGTools.Controls 2.0

ComboBox {
	id: control
	leftPadding: background.preview.width + spacing
	model: delegateRoot.modes
	textRole: "name"

	onActivated: {
		delegateRoot.mode = index
	}

	function closeColorDialog() {
		colorDialogBtn.closeDialog()
	}

	contentItem: ColorEditContent {}
	background: ColorEditBackground {}

	Binding on currentIndex {
		value: delegateRoot.mode
	}

	Binding {
		target: control.popup
		property: "width"
		value: Math.max(control.width, 100)
	}

	ColorDialogButton {
		id: colorDialogBtn
		width: control.background.preview.width
		height: control.height
	}
}
