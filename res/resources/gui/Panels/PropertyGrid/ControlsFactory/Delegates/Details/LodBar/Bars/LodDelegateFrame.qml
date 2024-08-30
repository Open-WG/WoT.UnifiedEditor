import QtQuick 2.7
import "../../../Settings.js" as Settings

Rectangle {
	width: parent.width
	height: parent.height
	color: "transparent"
	opacity: (control.hovered && !control.editing) ? 1 : 0;

	border.width: Settings.lodDelegateFrameWidth
	border.color: _palette.color12
	anchors.fill: parent

	Behavior on opacity {
		NumberAnimation { duration: Settings.interactionAnimDuration; easing.type: Easing.OutCubic }
	}
}
