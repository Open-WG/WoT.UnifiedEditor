import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0 as Details
import WGTools.ControlsEx.Details 1.0 as Details
import WGTools.ControlsEx.Controllers 1.0

TextField {
	id: control

	property var clearStrategy: function() {
		control.clear()
		triggered()
	}
	signal triggered()

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		placeholder.implicitWidth + padding + rightPadding) || (contentWidth + leftPadding + rightPadding)

	leftPadding: indicator.x + indicator.width + spacing
	rightPadding: clearButton.visible ? clearButton.width + spacing : padding

	cursorDelegate: control.activeFocus && (indicator.x == control.padding) ? cursorComponent : null
	Component {id: cursorComponent; Details.CursorDelegate {textInput: control}}

	Accessible.name: placeholderText

	Details.SearchFieldIndicator {id: indicator}
	Details.BasicIndicatorButton {
		id: clearButton
		width: ControlsSettings.height
		height: control.height
		x: control.width - width
		source: "controls-close"
		opacity: control.text != ""
		Accessible.name: "Clear"

		onClicked: {
			control.clearStrategy()
			control.forceActiveFocus()
		}
	}

	Keys.forwardTo: controller
	SearchFieldController {
		id: controller
		onRollback: control.text = oldValue
		onModified: if (commit) {
			control.focus = false
		}
	}

	Timer {
		id: timer
		interval: 300
		onTriggered: control.triggered()
	}

	onTextChanged: timer.restart()
	Keys.onReturnPressed: {
		timer.stop()
		timer.triggered()
	}
}
