import QtQuick 2.7
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0

import WGTools.Shapes 1.0 as Shapes
import "..//Constants.js" as Constants
import "..//Debug"

MenuItem {
	id: root
	
	leftPadding: 10
	rightPadding: 10
	hoverEnabled: true

	height: visible ? 30 : 0

	background: Rectangle {
		id: menuItem
		color: Constants.popupBackgroundColor

		Rectangle {
			id: frame

			anchors.fill: parent

			color: "transparent"
			border.color: root.hovered ? Constants.popupHoveredBorderColor : "transparent"
			border.width: Constants.popupHoveredBorderWidth
		}
	}

	contentItem: Text {
		id: content

		readonly property real arrowPadding: root.subMenu && root.arrow ? root.arrow.width + root.spacing : 0
		readonly property real indicatorPadding: root.menu.hasCheckable ? indicator.width + root.spacing : 0
		leftPadding: !root.mirrored ? indicatorPadding : arrowPadding
		rightPadding: root.mirrored ? indicatorPadding : arrowPadding

		text: root.text
		verticalAlignment: Text.AlignVCenter
		color: enabled ? "white" : "grey"

		font.family: Constants.proximaRg
		font.bold: true
		font.pixelSize: 12

		elide: Text.ElideRight
	}

	indicator: Image {
		id: indicatorImage

		x: root.mirrored ? root.width - width - root.rightPadding : root.leftPadding

		width: 12
		height: width

		visible: checked

		fillMode: Image.Pad

		source: Constants.iconCheckmark
		sourceSize.width: 10
		sourceSize.height: 10

		anchors.verticalCenter: parent.verticalCenter

		ColorOverlay {
			anchors.fill: parent

			source: indicatorImage
			color: "white"
		}
	}

	arrow: Shapes.Triangle {
		x: root.mirrored ? root.leftPadding : root.width - width - root.rightPadding

		width: 12
		height: 6

		visible: root.subMenu

		anchors.verticalCenter: parent.verticalCenter

		color: enabled ? "white" : "grey"
		rotation: -90
	}

	Keys.onPressed: {
		event.accepted = true
	}
}
