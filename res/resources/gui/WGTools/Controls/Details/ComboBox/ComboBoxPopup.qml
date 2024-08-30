import QtQuick 2.11
import QtQuick.Window 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

Popup {
	id: popup

	property real minWidth: control.width
	property real maxWidth: control.Window.width - rightMargin - rightMargin
	property real preferredWidth: ControlsSettings.veryLongWidth

	width: Math.min(Math.max(minWidth, preferredWidth), maxWidth)
	topPadding: ControlsSettings.padding
	bottomPadding: ControlsSettings.padding
	modal: true
	closePolicy: Popup.CloseOnEscape |
				 Popup.CloseOnPressOutside |
				 Popup.CloseOnReleaseOutside // Qt 5.9.1 doesn't close popup on press outside for some reason, so close also on release

	contentItem: ComboBoxPopupContent {}

	onOpened: arrange()
	onImplicitHeightChanged: arrange()

	function arrange() {
		var offset = ControlsSettings.spacing
		var controlPosition = mapToItem(null, control.x, control.y)

		var bottonSpace = control.Window.height - (controlPosition.y + control.height + offset + bottomMargin)
		if (bottonSpace >= implicitHeight) {
			height = implicitHeight
			y = control.height + offset
			return
		}

		var topSpace = controlPosition.y - (offset + topMargin)
		if (topSpace <= bottonSpace) {
			height = bottonSpace
			y = control.height + offset
			return
		}

		height = Math.min(topSpace, implicitHeight)
		y = -(height + offset)
	}
}
