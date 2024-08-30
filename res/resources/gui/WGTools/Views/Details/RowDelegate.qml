import QtQuick 2.11
import "ViewsSettings.js" as ViewsSettings

Rectangle {
	property var active
	property var current
	property bool hovered: false

	readonly property bool __active: (active !== undefined) 
		? active
		: styleData.hasOwnProperty("hasActiveFocus")
			? styleData.hasActiveFocus
			: false

	readonly property bool __current: (current !== undefined) 
		? current
		: styleData.hasOwnProperty("current")
			? styleData.current
			: __active

	readonly property bool __hovered: styleData.hovered || hovered

	height: ViewsSettings.rowDelegateHeight
	color: styleData.selected
		? __active
			? _palette.color13
			: Qt.tint(_palette.color13, _palette.hoveredTint)
		: styleData.alternate
			? typeof alternateBackgroundColor != "undefined"
				? alternateBackgroundColor
				: "transparent"
			: typeof backgroundColor != "undefined"
				? backgroundColor
				: "transparent"

	border.color: __hovered ? _palette.color12 : _palette.color13
	border.width: __hovered || __current
		? ViewsSettings.rowDelegateHoveredBorderWidth
		: ViewsSettings.rowDelegateBorderWidth

	Accessible.ignored: true
}
