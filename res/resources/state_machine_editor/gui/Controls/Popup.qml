import QtQuick 2.7
import QtQuick.Templates 2.2 as T

import "Details" as Details
import "Details//Settings.js" as ControlsSettings

T.Popup {
	id: control

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		contentWidth > 0 ? contentWidth + leftPadding + rightPadding : 0)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		contentHeight > 0 ? contentHeight + topPadding + bottomPadding : 0)

	contentWidth: contentItem.implicitWidth || (contentChildren.length === 1 ? contentChildren[0].implicitWidth : 0)
	contentHeight: contentItem.implicitHeight || (contentChildren.length === 1 ? contentChildren[0].implicitHeight : 0)
	padding: ControlsSettings.radius
	margins: ControlsSettings.popupMargins

	font.family: ControlsSettings.fontFamily
	font.pixelSize: ControlsSettings.textNormalSize

	contentItem: Item {}
	background: Details.PopupBackground {}

	enter: Details.PopupEnterTransition {}
	exit: Details.PopupExitTransition {}

	function toggle() {
		if (visible)
			close()
		else
			open()
	}
}
