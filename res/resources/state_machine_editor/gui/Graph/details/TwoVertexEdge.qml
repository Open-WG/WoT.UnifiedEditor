import QtQuick 2.7
import WGTools.Shapes 1.0 as Shapes
import QtQml.Models 2.2

Item {
	id: root
	property var centerOffset: 5

	property bool selected: styleData.selectionModel ?
		styleData.selectionModel.isSelected(index) : false

	Rectangle {
		id: edge

		visible: root.visible

		readonly property var centerX: (styleData.toX + styleData.fromX) / 2
		readonly property var centerY: (styleData.toY + styleData.fromY) / 2
		readonly property vector2d dir: Qt.vector2d(styleData.toX - styleData.fromX, 
			styleData.toY - styleData.fromY).normalized()

		readonly property var xOffset: root.centerOffset * -dir.y
		readonly property var yOffset: root.centerOffset * dir.x

		x: centerX - (width / 2) + xOffset
		y: centerY - height / 2 + yOffset

		anchors.alignWhenCentered: false

		width: calculateWidth()
		height: 1

		rotation: calculateRotation()

		antialiasing: true

		color: root.selected ? "#0093ff" : "#d4d4d4"

		MouseArea {
			anchors.fill: parent
			anchors.margins: -3
			acceptedButtons: Qt.LeftButton

			onPressed: {
				forceActiveFocus()

				if (mouse.button == Qt.LeftButton && styleData) {
					styleData.selectionModel.select(index, ItemSelectionModel.ClearAndSelect)
				}
			}
		}

		Item {
			y: edge.height / 2 - triangle.width / 2
			x: edge.width / 2 - triangle.height / 2

			width: 10
			height: 10

			Shapes.Triangle {
				id: triangle

				visible: parent.visible

				width: 10
				height: 10

				color: edge.color

				rotation: -90
			}
		}

		Connections {
			target: styleData ? styleData.selectionModel : null
			ignoreUnknownSignals: false
			onSelectionChanged: {
				var newState = styleData.selectionModel.isSelected(index);
				if (newState != root.selected)
					root.selected = newState
			}
		}

		function calculateWidth() {
			var x = styleData.toX - styleData.fromX
			var y = styleData.toY - styleData.fromY

			return Math.sqrt(x*x + y*y)
		}

		function calculateRotation() {
			return Math.atan2(styleData.toY - styleData.fromY,
				styleData.toX - styleData.fromX) * 180 / Math.PI
		}
	}
}