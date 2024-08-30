import QtQuick 2.11

Text {
	x: parent.leftPadding
	y: parent.topPadding
	width: parent.width - (parent.leftPadding + parent.rightPadding)
	height: parent.height - (parent.topPadding + parent.bottomPadding)

	text: parent.placeholderText
	font: parent.font
	// color: parent.placeholderTextColor Qt 5.12
	color: _palette.color3
	horizontalAlignment: parent.horizontalAlignment
	verticalAlignment: parent.verticalAlignment
	visible: !parent.length && !parent.preeditText && (!parent.activeFocus || parent.horizontalAlignment !== Qt.AlignHCenter)
	elide: Text.ElideRight
}
