import QtQuick 2.7
import QtQuick.Window 2.3
import QtQuick.Templates 2.2 as T
import Controls 1.0 as SMEControls

import "Settings.js" as ControlsSettings

SMEControls.Popup {
	width: Math.max(control.width, ControlsSettings.minimumComboBoxPopupWidth)

	topPadding: 10
	bottomPadding: 10

	closePolicy: T.Popup.CloseOnEscape |
				 T.Popup.CloseOnPressOutside |
				 T.Popup.CloseOnReleaseOutside; // Qt 5.9.1 doesn't close popup on press outside for some reason, so close also on release

	modal: true
	contentItem: ComboBoxPopupContent {}

	background: Rectangle {
		border.width: ControlsSettings.thinBorderWidth
		border.color: "#ffffff"
		color: "#666666"
		radius: ControlsSettings.radius
	}

	onOpened: arrange()
	onImplicitHeightChanged: arrange()

	function arrange() {
		var controlPosition = mapToItem(null, control.x, control.y)
		var topAvailableSpace = controlPosition.y
		var bottomAvailableSpace = control.Window.height - controlPosition.y - control.height
		var maxAvailableHeight = Math.max(topAvailableSpace, bottomAvailableSpace) - topMargin - bottomMargin - ControlsSettings.popupYOffset

		height = Math.min(maxAvailableHeight, implicitHeight)
		y = (topAvailableSpace > bottomAvailableSpace) 
			? -height - ControlsSettings.popupYOffset 
			: control.height + ControlsSettings.popupYOffset
	}
}
