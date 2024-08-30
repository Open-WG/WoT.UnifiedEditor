import QtQuick 2.11
import WGTools.Templates 1.0 as T
import WGTools.Controls.Details 2.0 as Details

T.ToolTip {
	id: control

	x: parent ? (parent.width - implicitWidth) / 2 : 0
	y: -implicitHeight - 3

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		contentItem.implicitWidth + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		contentItem.implicitHeight + topPadding + bottomPadding)

	margins: ControlsSettings.popupMargins
	windowMargins: background && background.hasOwnProperty("shadowRadius") ? background.shadowRadius : 0
	padding: ControlsSettings.smallPadding
	leftPadding: ControlsSettings.padding
	rightPadding: ControlsSettings.padding

	closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside | T.Popup.CloseOnReleaseOutside

	contentItem: Details.ToolTipContent {}
	background: Details.ToolTipBackground {}
}
