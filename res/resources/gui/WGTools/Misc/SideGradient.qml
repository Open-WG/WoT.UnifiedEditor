import QtQuick 2.7

Item {
	id: root

	property color mainColor: "transparent"
	property color sideColor: "red"
	property real startGradientSize: 10
	property real endGradientSize: 10
	property int orientation: Qt.Vertical

	implicitWidth: 10
	implicitHeight: 10

	Rectangle {
		id: rect

		readonly property bool vertical: parent.orientation == Qt.Vertical
		readonly property bool totalGradientSize: startGradientSize + endGradientSize
		readonly property bool shrink: totalGradientSize > height

		width: vertical ? parent.width : parent.height
		height: vertical ? parent.height : parent.width
		transformOrigin: Item.TopLeft
		rotation: vertical ? 0 : 90

		gradient: Gradient {
			GradientStop {
				color: root.sideColor
				position: 0.0
			}

			GradientStop {
				color: root.mainColor
				position: rect.shrink
					? startGradientSize / rect.totalGradientSize
					: root.startGradientSize / rect.height
			}

			GradientStop {
				color: root.mainColor
				position: rect.shrink
					? startGradientSize / rect.totalGradientSize
					: 1.0 - root.endGradientSize / rect.height
			}

			GradientStop {
				color: root.sideColor
				position: 1.0
			}
		}

		anchors.top: vertical ? undefined : parent.top
		anchors.left: vertical ? undefined : parent.right
	}
}