import QtQuick 2.7
import WGTools.Shapes 1.0 as Shapes
import QtQml.Models 2.2

Item {
	id: root

	property bool selected: styleData.selectionModel ? styleData.selectionModel.isSelected(index) : false

	readonly property var _lineOffset: styleData.vertexHeight / 2

	Rectangle {
		id: selfEdgePart1

		visible: root.visible

		color: root.selected ? "#0093ff" : "#d4d4d4"

		x: styleData.fromX + 5
		y: styleData.fromY - height

		width: 1
		height: styleData.vertexHeight / 2 + _lineOffset

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
	}

	Rectangle {
		id: selfEdgePart2

		visible: root.visible

		color: root.selected ? "#0093ff" : "#d4d4d4"

		x: selfEdgePart1.x
		y: selfEdgePart1.y

		width: styleData.vertexWidth / 2 + _lineOffset
		height: 1

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
	}

	Rectangle {
		id: selfEdgePart3

		visible: root.visible

		color: root.selected ? "#0093ff" : "#d4d4d4"

		x: selfEdgePart2.x + selfEdgePart2.width
		y: selfEdgePart2.y

		width: 1
		height: selfEdgePart1.height * 2

		Item {
			anchors.centerIn: parent

			width: 10
			height: 10

			Shapes.Triangle {
				anchors.centerIn: parent

				visible: parent.visible

				width: 10
				height: 10

				color: selfEdgePart3.color
			}
		}

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
	}

	Rectangle {
		id: selfEdgePart4

		visible: root.visible

		color: root.selected ? "#0093ff" : "#d4d4d4"

		x: selfEdgePart1.x
		y: selfEdgePart3.y + selfEdgePart3.height - 1

		width: styleData.vertexWidth / 2 + _lineOffset
		height: 1

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
	}

	Rectangle {
		id: selfEdgePart5

		visible: root.visible

		color: root.selected ? "#0093ff" : "#d4d4d4"

		x: selfEdgePart4.x
		y: selfEdgePart4.y - height

		width: 1
		height: selfEdgePart1.height

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
}