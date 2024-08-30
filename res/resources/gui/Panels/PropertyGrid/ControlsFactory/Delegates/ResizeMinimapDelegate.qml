import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0
import WGTools.Misc 1.0 as Misc
import WGTools.PropertyGrid 1.0
import WGTools.Utils 1.0

import "Settings.js" as Settings

ResizeMinimapDelegate {
	id: delegateRoot

	property var model 
	anchors.centerIn: parent

	readonly property int lineWidth: 2
	readonly property int offsetX: 25
	readonly property int offsetY: 25
	readonly property int pixelWidth: 400
	readonly property int pixelHeight: 400

	implicitWidth: pixelWidth + offsetX * 2
	implicitHeight: pixelHeight + offsetY * 2

	readonly property int innerWidth: width - offsetX * 2
	readonly property int innerHeight: height - offsetY * 2

	propertyData: model ? model.node.property : null

	enabled: propertyData && !propertyData.readonly

	readonly property int max_space_size : 32
	readonly property int rescaleBorder : max_space_size / 4
	readonly property int scale : isDimensionsBig() ? 1 : 2
	readonly property int stepSize : (innerHeight / max_space_size) * scale

	function isDimensionsBig () {
		return Math.abs(verticalAxis.x) >= rescaleBorder
				|| Math.abs(verticalAxis.y) >= rescaleBorder
				|| Math.abs(horizontalAxis.x) >= 2 * rescaleBorder
				|| Math.abs(horizontalAxis.y) >= 2 * rescaleBorder
	}

	readonly property var center : Qt.point(width / 2, height / 2)

	// Coordinates of the corner points of the resizing rectangle
	readonly property var topLeft     :
		Qt.point(center.x + delegateRoot.horizontalAxis.x * stepSize, center.y - delegateRoot.verticalAxis.y * stepSize)
	readonly property var topRight    :
		Qt.point(center.x + delegateRoot.horizontalAxis.y * stepSize, center.y - delegateRoot.verticalAxis.y * stepSize)
	readonly property var bottomLeft  :
		Qt.point(center.x + delegateRoot.horizontalAxis.x * stepSize, center.y - delegateRoot.verticalAxis.x * stepSize)
	readonly property var bottomRight :
		Qt.point(center.x + delegateRoot.horizontalAxis.y * stepSize, center.y - delegateRoot.verticalAxis.x * stepSize)

	// Corner points of the resizing rectangle
	Repeater {
		model: [{"pos" : topLeft	 },
				{"pos" : topRight	 },
				{"pos" : bottomLeft },
				{"pos" : bottomRight}]

		Rectangle {
			width: 6
			height: width
			color: _palette.redChannel
			radius: width / 2
			x: modelData.pos.x - width / 2
			y: modelData.pos.y - height / 2
		}
	}

	// Enumeration of resizing rectangle edges
	readonly property int leftSide	: 0
	readonly property int rightSide	: 1
	readonly property int topSide	: 2
	readonly property int bottomSide : 3

	// Resizing rectangle
	// It is represented as 4 edges connected at corner points
	// Each edge has its own Rectangle, Misc.Text and MouseArea
	Repeater {
		model: [{"side" : leftSide  },
				{"side" : rightSide },
				{"side" : topSide	 },
				{"side" : bottomSide}]

		Rectangle {
			x: getX() - lineWidth / 2
			y: getY() - lineWidth / 2

			width: 	isHorizontal() 	? topRight.x - topLeft.x   : lineWidth
			height: !isHorizontal() ? bottomLeft.y - topLeft.y : lineWidth
			color: _palette.redChannel

			function isHorizontal() {
				return modelData.side == topSide || modelData.side == bottomSide
			}

			function getX() {
				if 		(modelData.side == leftSide)   return topLeft.x
				else if (modelData.side == rightSide)  return topRight.x
				else if (modelData.side == topSide)    return topLeft.x
				else if (modelData.side == bottomSide) return topLeft.x
			}

			function getY() {
				if 		(modelData.side == leftSide)   return topLeft.y
				else if (modelData.side == rightSide)  return topRight.y
				else if (modelData.side == topSide)    return topLeft.y
				else if (modelData.side == bottomSide) return bottomLeft.y
			}

			// Horizontal edges manipulates the vertical axis
			// Vertical edges manipulates the horizontal axis
			function getValue() {
				if 		(modelData.side == leftSide)   return delegateRoot.horizontalAxis.x
				else if (modelData.side == rightSide)  return delegateRoot.horizontalAxis.y
				else if (modelData.side == topSide)    return delegateRoot.verticalAxis.y
				else if (modelData.side == bottomSide) return delegateRoot.verticalAxis.x
			}

			// Only changes the value by +1 or -1
			function changeValue(dX, dY, setterFlags) {
				var delta = !isHorizontal() ? dX : -dY
				if 		(delta > 0 && delta >= delegateRoot.stepSize && delta <= delegateRoot.stepSize * 2)   addValue(1, setterFlags)
				else if (delta < 0 && delta <= -delegateRoot.stepSize && delta >= -delegateRoot.stepSize * 2) addValue(-1, setterFlags)
			}

			// Horizontal edges manipulates the vertical axis
			// Vertical edges manipulates the horizontal axis 
			function addValue(value, setterFlags) {
				if 	(modelData.side == leftSide)   
					delegateRoot.setHorizontalAxis(Qt.point(delegateRoot.horizontalAxis.x + value, delegateRoot.horizontalAxis.y), setterFlags)
				else if (modelData.side == rightSide)  
					delegateRoot.setHorizontalAxis(Qt.point(delegateRoot.horizontalAxis.x, delegateRoot.horizontalAxis.y + value), setterFlags)
				else if (modelData.side == topSide)    
					delegateRoot.setVerticalAxis(Qt.point(delegateRoot.verticalAxis.x, delegateRoot.verticalAxis.y + value), setterFlags)
				else if (modelData.side == bottomSide) 
					delegateRoot.setVerticalAxis(Qt.point(delegateRoot.verticalAxis.x + value, delegateRoot.verticalAxis.y), setterFlags)
			}

			Misc.Text {
				text: parent.getValue()

				x: parent.isHorizontal()
					? parent.width / 2 - width / 2
					: modelData.side == leftSide
						? -20
						: 10
				y: !parent.isHorizontal()
					? parent.height / 2 - height / 2
					: modelData.side == topSide
						? -20
						: 10
			}
				
			MouseArea {
				id: mouseArea

				property bool isEditing: false

				preventStealing: true
				acceptedButtons: Qt.LeftButton
				width: parent.width + 5
				height: parent.height + 5
				anchors.centerIn: parent

				onPressed: {
					isEditing = true
				}

				onReleased: {
					stopEdit()
				}

				function stopEdit() {
					isEditing = false

					var pos = mapToItem(parent, mouseX, mouseY)
					parent.changeValue(pos.x, pos.y, 0)
				}

				onPositionChanged: {
					if (isEditing) {
						if (!pressed) {
							stopEdit()
							return
						}
						var pos = mapToItem(parent, mouseX, mouseY)
						parent.changeValue(pos.x, pos.y, IValueData.TRANSIENT)
					}
				}
			}
		}
	}

	// The grid is wrapped in an item to clip it to its parent's size
	Item {
		id: itemRoot

		width: innerWidth
		height: innerHeight
		anchors.centerIn: parent
		clip: true
		z: -1

		Grid {
			anchors.centerIn: parent
			rows: max_space_size
			columns: max_space_size

			Repeater {
				model: max_space_size * max_space_size
				Rectangle {
					width: stepSize
					height: width
					color: "transparent"
					border.color: _palette.color1
					opacity: 0.2
					border.width: 1
				}
			}
		}

		readonly property var center : Qt.point(width / 2, height / 2)

		// Root center point
		Rectangle {
			width: 6
			height: width
			radius: width / 2
			x: itemRoot.center.x - width / 2
			y: itemRoot.center.y - height / 2
		}

		// Minimap
		Image {
			id: map

			readonly property alias bottomLeft: delegateRoot.minimapBottomLeft
			readonly property alias topRight: delegateRoot.minimapTopRight

			x: itemRoot.center.x + bottomLeft.x * stepSize
			y: itemRoot.center.y - topRight.y * stepSize - stepSize 

			source: delegateRoot.minimapPath.length ? "file:///" + delegateRoot.minimapPath : ""
			width:  (topRight.x - bottomLeft.x + 1) * stepSize
			height: (topRight.y - bottomLeft.y + 1) * stepSize
			opacity: 0.5
		}

		
		// Rectangle that shows initial dimensions
		Rectangle {
			property var horizontalAxis: Qt.point(delegateRoot.horizontalAxis.x, delegateRoot.horizontalAxis.y)
			property var verticalAxis:   Qt.point(delegateRoot.verticalAxis.x, delegateRoot.verticalAxis.y)

			x: itemRoot.center.x + horizontalAxis.x * stepSize - lineWidth / 2
			y: itemRoot.center.y - verticalAxis.y * stepSize - lineWidth / 2
			width: (horizontalAxis.y - horizontalAxis.x) * stepSize + lineWidth
			height: (verticalAxis.y - verticalAxis.x) * stepSize + lineWidth
			color: "transparent"
			border.width: lineWidth
			border.color: _palette.greenChannel
			
			// Unbinding properties
			Component.onCompleted: {
				horizontalAxis = horizontalAxis
				verticalAxis = verticalAxis
			}
		}
	}
}
