import QtQuick 2.7
import QtQuick.Templates 2.2 as T

import "Details" as Details
import "Details//Settings.js" as ControlsSettings

T.ComboBox {
	id: control

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		contentItem.implicitWidth + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		Math.max(contentItem.implicitHeight,
				 indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)

	baselineOffset: contentItem.y + contentItem.baselineOffset
	spacing: ControlsSettings.spacing
	padding: ControlsSettings.normalHPadding
	rightPadding: padding + ((indicator && indicator.visible) ? indicator.width + spacing : 0);
	topPadding: ControlsSettings.normalVPadding
	bottomPadding: ControlsSettings.normalVPadding
	hoverEnabled: true

	font.family: "Proxima Nova Rg"
	font.pixelSize: 12

	indicator: Details.ComboBoxIndicator {}
	contentItem: Details.ComboBoxContent {}
	background: Details.ButtonBackground {
	}

	delegate: Details.ComboBoxDelegate {}
	popup: Details.ComboBoxPopup {}
}
