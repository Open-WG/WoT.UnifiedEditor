import QtQuick 2.7
import QtQuick.Controls 2.0

import "..//Constants.js" as Constants

Menu {
	readonly property var maxWidth: 150
	readonly property bool hasCheckable: {
		for (var i = 0; i < count; ++i) {
			if (itemAt(i).checkable) {
				return true
			}
		}

		return false
	}

	width: {
		var newWidth = 0
		for (var i = 0; i < count; ++i) {
			var currWidth = itemAt(i).width
			if (newWidth < currWidth)
				newWidth = currWidth
		}

		newWidth += leftPadding + rightPadding

		return newWidth > maxWidth ? maxWidth : newWidth
	}

	modal: true
	focus: true

	topPadding: Constants.popupDefaultTopPadding
	bottomPadding: Constants.popupDefaultBottomPadding
	leftPadding: Constants.popupDefaultLeftPadding
	rightPadding: Constants.popupDefaultRightPadding

	font.family: Constants.proximaRg
	font.bold: true
	font.pixelSize: 12
	
	background: Rectangle {
		id: popupBackground
		color: Constants.popupBackgroundColor
		radius: Constants.addPopupTrackRadius

		border.color: "black"
		border.width: 1
	}
}
