import QtQuick 2.7
import QtGraphicalEffects 1.0

Item {
	id: root

	property alias preview: preview
	readonly property real _radius: parent.radius
	readonly property real _borderWidth: parent.border.width
	readonly property color _borderColor: parent.border.color

	Item {
		id: item
		width: parent.width
		height: parent.height
		visible: false
		layer.enabled: true

		ColorPreview {
			id: preview
			width: parent.height
			height: parent.height
		}
	}

	Rectangle {
		id: mask
		width: parent.width
		height: parent.height
		color: "#FFFFFF"
		radius: root._radius
		visible: false
	}

	OpacityMask {
		width: parent.width
		height: parent.height
		source: item
		maskSource: mask
		cached: true
	}

	Rectangle {
		width: parent.width
		height: parent.height
		color: "transparent"
		radius: root._radius
		border.width: root._borderWidth
		border.color: root._borderColor
	}
}
