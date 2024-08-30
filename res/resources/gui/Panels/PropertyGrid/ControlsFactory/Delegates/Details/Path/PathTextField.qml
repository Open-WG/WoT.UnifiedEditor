import QtQuick 2.11
import WGTools.Controls.Details 2.0 as Details
import "../TextField"

TextField {
	id: control

	property var pathButtonReadOnly: readOnly
	property alias dialogButton: dialogButton

	isPath: true

	rightPadding: separator.visible ? dialogButton.width + separator.width + spacing : 0

	Accessible.name: "Path"

	Details.TextFieldSeparator {
		id: separator
		x: dialogButton.x - width
		visible: dialogButton.visible
	}

	PathDialogButton {
		id: dialogButton
		width: ControlsSettings.height
		height: ControlsSettings.height
		x: control.width - width
		y: control.topPadding + (control.availableHeight - height) / 2
		enabled: !control.pathButtonReadOnly
	}
}
