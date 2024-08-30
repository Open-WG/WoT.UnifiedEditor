import QtQuick 2.7
import QtQml 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import WGTools.Controls.Details 2.0
import "..//Toolbar"

ToolbarCaptionWrapper {
	id: control

	property alias text: textField.text
	property alias caption: control.text

	signal editingFinished

	implicitWidth: 72
	
	function setEditText(number) {
		// converts number to string
		textField.text = number + "f"
	}

	TextField {
		id: textField
		text: "0f"
		validator: RegExpValidator { regExp: /^(0|([1-9][0-9]*))(\.[0-9]*)?(f|s|m)?|(f|s|m)?$/ }
		implicitHeight: 20
		implicitWidth: 72
		
		Layout.alignment: Qt.AlignHCenter

		onEditingFinished: {
			control.editingFinished()
		}
	}

	background: null

	ToolTip.text: control.caption
	ToolTip.visible: hovered
	ToolTip.delay: ControlsSettings.tooltipDelay
	ToolTip.timeout: ControlsSettings.tooltipTimeout
}
