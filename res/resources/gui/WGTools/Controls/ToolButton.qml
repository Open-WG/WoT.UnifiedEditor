import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details

T.ToolButton {
	id: control

	property bool iconicStyle: false
	readonly property color _iconColor: enabled
		? (checked && !iconicStyle) 
			? _palette.color1
			: hovered 
				? _palette.color1
				: _palette.color2
		: _palette.color3

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		contentItem.implicitWidth + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		contentItem.implicitHeight + topPadding + bottomPadding)

	baselineOffset: contentItem.y + contentItem.baselineOffset
	spacing: ControlsSettings.spacings
	padding: 0
	flat: true

	icon.width: ControlsSettings.iconSize
	icon.height: ControlsSettings.iconSize
	icon.color: Qt.rgba(_iconColor.r, _iconColor.g, _iconColor.b, down ? 0.5 : 1)

	ToolTip.delay: ControlsSettings.tooltipDelay
	ToolTip.timeout: ControlsSettings.tooltipTimeout
	ToolTip.visible: hovered && ToolTip.text.length

	contentItem: Details.ToolButtonContent {}
	background: Details.ToolButtonBackground {}

	Details.BackgroundBB {}
	Details.ContentItemBB {}
	Details.IndicatorBB {}
}
