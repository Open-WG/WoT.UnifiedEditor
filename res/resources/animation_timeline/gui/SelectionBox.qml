import QtQuick 2.7

import "Constants.js" as Constants

Rectangle {
	id: root

	color: Qt.rgba(border.color.r, border.color.g,
		border.color.b, 0.2)

	border.width: 2
	border.color: Constants.selectionColor
}