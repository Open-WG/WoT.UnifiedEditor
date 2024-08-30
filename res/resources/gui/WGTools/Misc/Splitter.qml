import QtQuick 2.7

Item {
	id: root

	property real initialPosition: 0
	property real thickness: 10
	property bool horizontal: true

	property alias handleSource: handleLoader.sourceComponent
	property alias handleComponent: handleLoader.sourceComponent

	readonly property real position: dragArea.horizontal ? dragArea.x : dragArea.y
	readonly property alias value: dragArea.value

	Connections {
		onHorizontalChanged: {
			if (horizontal)
			{
				dragArea.x = dragArea.drag.maximumX * dragArea.value
				dragArea.horizontal = true
				dragArea.y = 0
			}
			else
			{
				dragArea.y = dragArea.drag.maximumY * dragArea.value
				dragArea.horizontal = false
				dragArea.x = 0
			}
		}

		Component.onCompleted: {
			dragArea.setPosition(initialPosition)
		}
	}

	MouseArea {
		id: dragArea

		property bool horizontal: true
		property real value: horizontal
			? drag.maximumX > 0 ? x / drag.maximumX : 0
			: drag.maximumY > 0 ? y / drag.maximumY : 0

		width: horizontal ? root.thickness : parent.width
		height: horizontal ? parent.height : root.thickness
		cursorShape: horizontal ? Qt.SizeHorCursor : Qt.SizeVerCursor
		hoverEnabled: true
		preventStealing: true

		drag.target: dragArea
		drag.axis: horizontal ? Drag.XAxis : Drag.YAxis
		drag.minimumX: 0
		drag.maximumX: Math.max(0, root.width - root.thickness)
		drag.minimumY: 0
		drag.maximumY: Math.max(0, root.height - root.thickness)

		function setPosition(position) {
			if (horizontal)
			{
				dragArea.x = position
			}
			else
			{
				dragArea.y = position
			}
		}

		Loader {
			id: handleLoader
			anchors.fill: parent

			property QtObject styleData: QtObject {
				readonly property bool hovered: dragArea.containsMouse
				readonly property bool pressed: dragArea.pressed
				readonly property bool dragging: dragArea.drag.active
			}
		}
	}
}
