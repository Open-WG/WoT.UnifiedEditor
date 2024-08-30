import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details

T.ScrollBar {
	id: control

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		contentItem.implicitWidth + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		contentItem.implicitHeight + topPadding + bottomPadding)

	padding: 0
	minimumSize: ControlsSettings.scrollbarMinimumSize / (horizontal ? availableWidth : availableHeight)
	hoverEnabled: true
	visible: policy !== T.ScrollBar.AlwaysOff

	contentItem: Details.ScrollBarHandle {}
	background: null
}
