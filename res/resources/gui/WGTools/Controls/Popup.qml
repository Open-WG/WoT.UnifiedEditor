import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details
import WGTools.Controls.impl 1.0 as Impl

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

	padding: ControlsSettings.strokeWidth
	topPadding: ControlsSettings.radius
	bottomPadding: ControlsSettings.radius
	margins: ControlsSettings.popupMargins

	font.family: ControlsSettings.fontFamily
	font.pixelSize: ControlsSettings.textNormalSize

	contentItem: Item {}
	background: Details.PopupBackground {
		id: popupBackground
	}

	enter: Details.PopupEnterTransition {}
	exit: Details.PopupExitTransition {}

	Impl.PopupWindow.margins: popupBackground.shadowRadius

	function popupEx() {
		Impl.PopupWindow.popup()
	}

	function openEx() {
		Impl.PopupWindow.open()
	}

	function toggle() {
		if (visible)
			close()
		else
			open()
	}
}
