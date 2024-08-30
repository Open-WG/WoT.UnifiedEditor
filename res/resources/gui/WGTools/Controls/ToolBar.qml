import QtQuick 2.10
import QtQuick.Templates 2.3 as T
import WGTools.Controls.Details 2.0 as Details

T.ToolBar {
	id: control
	implicitWidth: Math.max(background ? background.implicitWidth : 0, contentWidth) + leftPadding + rightPadding
	implicitHeight: Math.max(background ? background.implicitHeight : 0, contentHeight) + topPadding + bottomPadding
	
	contentWidth: contentItem.implicitWidth || (contentChildren.length === 1 ? contentChildren[0].implicitWidth : 0)
	contentHeight: contentItem.implicitHeight || (contentChildren.length === 1 ? contentChildren[0].implicitHeight : 0)
	padding: ControlsSettings.toolBarPadding

	background: Details.ToolBarBackground {}
}
