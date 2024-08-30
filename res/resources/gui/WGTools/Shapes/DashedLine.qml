import QtQuick 2.11

Item {
	id: container

	property int dash: 3
	property int space: 3
	property color color: "white"

	implicitWidth: 1
	opacity: 0.3
	clip: true

	layer.enabled: true

	Repeater {
		id: repeater

		readonly property int stride: container.dash + container.space
		model: stride > 0 ? Math.ceil(container.height / stride) : null

		Rectangle {
			width: parent.width
			height: container.dash
			y: index * repeater.stride
			color: container.color
		}
	}
}
