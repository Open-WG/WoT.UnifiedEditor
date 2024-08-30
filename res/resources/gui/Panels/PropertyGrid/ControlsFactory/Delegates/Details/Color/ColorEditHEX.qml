import QtQuick 2.7
import WGTools.Controls 2.0
import WGTools.Controls.Controllers 1.0

TextField {
	id: control
	implicitWidth: 70
	topPadding: 0
	bottomPadding: 0
	background: null
	font.bold: true

	Accessible.name: "HEX"

	Keys.forwardTo: controller
	Keys.onEscapePressed: focus = false

	Binding on text {
		when: !control.activeFocus
		value: delegateRoot.hex
	}

	Binding on color {
		when: !delegateRoot.isValidHEX(control.text)
		value: "red"
	}

	TextFieldController {
		id: controller
		onModified: {
			delegateRoot.setHEX(control.text, !commit)

			if (commit) {
				text = delegateRoot.hex
			}
		}
	}
}
