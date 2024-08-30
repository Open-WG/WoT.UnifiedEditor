import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details

T.ItemDelegate {
	id: control
	Accessible.name: text

	// Accessible.name: model.display ? model.display : ""

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		(contentItem ? contentItem.implicitWidth : 0) + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		Math.max(
			contentItem ? contentItem.implicitHeight : 0,
			indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)

	baselineOffset: contentItem ? contentItem.y + contentItem.baselineOffset : 0
	spacing: ControlsSettings.spacing
	padding: ControlsSettings.padding
	topPadding: ControlsSettings.smallPadding
	bottomPadding: ControlsSettings.smallPadding
	hoverEnabled: true

	font.family: ControlsSettings.fontFamily
	font.pixelSize: ControlsSettings.textNormalSize
	font.hintingPreference: Font.PreferFullHinting

	icon.width: ControlsSettings.iconSize
	icon.height: ControlsSettings.iconSize
	icon.color: _palette.color2

	contentItem: Details.ItemDelegateContent {}
	background: Details.ItemDelegateBackground {}

	Details.ColorBehavior on icon.color {}
	Details.BackgroundBB {}
	Details.ContentItemBB {}
	Details.IndicatorBB {}
}
