import QtQuick 2.10
import "ViewsSettings.js" as ViewsSettings

Rectangle {
	property var active
	property bool hovered: false

	readonly property bool __active: (active !== undefined) 
		? active 
		: styleData.hasOwnProperty("hasActiveFocus")
			? styleData.hasActiveFocus
			: false

	readonly property color _origColor: styleData.alternate
		? typeof alternateBackgroundColor != "undefined"
			? alternateBackgroundColor
			: "transparent"
		: typeof backgroundColor != "undefined"
			? backgroundColor
			: "transparent"

	height: ViewsSettings.rowDelegateHeight
	color: styleData.selected
		? __active
			? _palette.color13
			: Qt.tint(_palette.color13, _palette.hoveredTint)
		: _origColor

	border.color: _palette.color12
	border.width: (styleData.hovered || hovered)
		? ViewsSettings.rowDelegateHoveredBorderWidth
		: ViewsSettings.rowDelegateBorderWidth

	Accessible.ignored: true
}
