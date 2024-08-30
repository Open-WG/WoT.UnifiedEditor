import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details
import WGTools.Controls.impl 1.0

T.RadioButton {
	id: control
	Accessible.name: text || "RadioButton"

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		contentItem.implicitWidth + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		Math.max(
			contentItem.implicitHeight,
			indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)

	baselineOffset: contentItem.y + contentItem.baselineOffset
	spacing: ControlsSettings.spacing
	padding: 0
	topPadding: ControlsSettings.smallPadding
	bottomPadding: ControlsSettings.smallPadding

	font.family: ControlsSettings.fontFamily
	font.pixelSize: ControlsSettings.textNormalSize
	font.hintingPreference: Font.PreferFullHinting

	icon.color: Color.transparent(_palette.color1, enabled ? 1 : ControlsSettings.disabledOpacity)

	indicator: Details.RadioButtonIndicator {}
	contentItem: Details.CheckBoxContent {}

	Details.ColorBehavior on icon.color {}
	Details.BackgroundBB {}
	Details.ContentItemBB {}
}
