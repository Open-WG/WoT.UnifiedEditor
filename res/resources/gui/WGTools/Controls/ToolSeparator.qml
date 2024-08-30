import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0

T.ToolSeparator {
	id: control
	implicitWidth: Math.max(background ? background.implicitWidth : 0, contentItem.implicitWidth + leftPadding + rightPadding)
	implicitHeight: Math.max(background ? background.implicitHeight : 0, contentItem.implicitHeight + topPadding + bottomPadding)

	padding: horizontal ? Math.max(0, ControlsSettings.toolButtonWidth - ControlsSettings.toolSeparatorHeight) / 2 : 0
	topPadding: vertical ? Math.max(0, ControlsSettings.toolButtonWidth - ControlsSettings.toolSeparatorHeight) / 2 : 0
	bottomPadding: topPadding

	contentItem: Rectangle {
		implicitWidth: vertical ? ControlsSettings.thickStrokeWidth : ControlsSettings.toolSeparatorHeight
		implicitHeight: vertical ? ControlsSettings.toolSeparatorHeight : ControlsSettings.thickStrokeWidth
		color: _palette.color5
	}
}
