import QtQuick 2.7

Rectangle {
	readonly property bool hovered: __activeControl !== "none"

	implicitWidth: styleData.horizontal
		? parent.width
		: hovered
			? style.hoveredHandleSize
			: style.handleSize

	implicitHeight: styleData.horizontal
		? hovered
			? style.hoveredHandleSize
			: style.handleSize
		: parent.width

	color: (styleData.hovered || styleData.pressed || control.flickableItem.moving)
		? _palette.color2
		: _palette.color2

	Behavior on color {
		enabled: !_palette.themeSwitching
		ColorAnimation { duration: style.animDuration }
	}

	Behavior on implicitWidth {
		enabled: !_palette.themeSwitching
		NumberAnimation { duration: style.animDuration }
	}

	Behavior on implicitHeight {
		enabled: !_palette.themeSwitching
		NumberAnimation { duration: style.animDuration }
	}
}
