import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details

T.MenuItem {
	id: control

	Accessible.name: text
	readonly property int type: Details.ControlsConstants.MenuItemType.MenuItem

	width: parent ? parent.width : implicitWidth
	height: visible ? implicitHeight : 0

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		contentItem.implicitWidth + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		Math.max(contentItem.implicitHeight, indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)

	baselineOffset: contentItem.y + contentItem.baselineOffset

	spacing: ControlsSettings.spacing
	padding: ControlsSettings.padding
	topPadding: ControlsSettings.smallPadding
	bottomPadding: ControlsSettings.smallPadding
	hoverEnabled: true

	font {
		family: ControlsSettings.fontFamily
		pixelSize: ControlsSettings.textNormalSize
	}

	icon {
		width: ControlsSettings.iconSize
		height: ControlsSettings.iconSize
		color: checked || control.indicator ? _palette.color1 : _palette.color2
	}

	arrow: Details.MenuItemArrow {}
	indicator: Details.MenuItemIndicator {}
	contentItem: Details.MenuItemContent {}
	background: Details.MenuItemBackground {}
}
