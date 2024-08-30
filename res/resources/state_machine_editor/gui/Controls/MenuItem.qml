import QtQuick 2.7
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import Controls 1.0 as SMEControls

import WGTools.Shapes 1.0 as Shapes

MenuItem {
	id: root
	
	leftPadding: 10
	rightPadding: 10
	hoverEnabled: true

	height: visible ? 30 : 0

	width: menu 
		? Math.max(menu.width - menu.leftPadding - menu.rightPadding, 0)
		: implicitWidth

	background: Rectangle {
		id: menuItem
		color: "#4a4a4a"

		Rectangle {
			id: frame

			anchors.fill: parent

			color: "transparent"
			border.color: root.hovered ? "#0a70dd" : "transparent"
			border.width: 2
		}
	}

	contentItem: SMEControls.Text {
		id: content

		readonly property real arrowPadding: root.subMenu && root.arrow ? root.arrow.width + root.spacing : 0
		readonly property real indicatorPadding: root.menu.hasCheckable ? indicator.width + root.spacing : 0
		leftPadding: !root.mirrored ? indicatorPadding : arrowPadding
		rightPadding: root.mirrored ? indicatorPadding : arrowPadding

		text: root.text
		verticalAlignment: Text.AlignVCenter
		color: enabled ? "white" : "grey"

		elide: Text.ElideRight
	}

	arrow: Shapes.Triangle {
		x: root.mirrored ? root.leftPadding : root.width - width - root.rightPadding

		width: 12
		height: 6

		visible: root.subMenu

		anchors.verticalCenter: parent ? parent.verticalCenter : undefined

		color: enabled ? "white" : "grey"
		rotation: -90
	}
}
