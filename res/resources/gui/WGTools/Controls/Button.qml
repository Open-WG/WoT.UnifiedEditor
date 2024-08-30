import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details
import WGTools.Controls.impl 1.0

T.Button {
	id: control
	Accessible.name: text || "Button"

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		contentItem.implicitWidth + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		contentItem.implicitHeight + topPadding + bottomPadding)

	baselineOffset: contentItem.y + contentItem.baselineOffset
	spacing: ControlsSettings.spacing
	padding: ControlsSettings.smallPadding
	leftPadding: flat ? padding : ControlsSettings.padding
	rightPadding: flat ? padding : ControlsSettings.padding
	hoverEnabled: true

	font.family: ControlsSettings.fontFamily
	font.pixelSize: ControlsSettings.textNormalSize
	font.hintingPreference: Font.PreferFullHinting

	icon.color: Color.transparent(_palette.color1, enabled ? 1 : ControlsSettings.disabledOpacity)

	contentItem: Details.ButtonContent {}
	background: Details.ButtonBackground {}

	Details.ColorBehavior on icon.color {}
	Details.BackgroundBB {}
	Details.ContentItemBB {}
	Details.IndicatorBB {}
}
