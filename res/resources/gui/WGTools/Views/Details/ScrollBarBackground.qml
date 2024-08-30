import QtQuick 2.7

Rectangle {
	implicitWidth: styleData.horizontal
		? 0
		: styleData.hovered
			? style.hoveredHandleSize
			: style.handleSize

	implicitHeight: styleData.horizontal
		? styleData.hovered
			? style.hoveredHandleSize
			: style.handleSize
		: 0

	color: style.scrollBarBackgroundColor

	Behavior on implicitWidth {
		enabled: !_palette.themeSwitching
		NumberAnimation { duration: style.animDuration }
	}
}
