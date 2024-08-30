import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0
import WGTools.Misc 1.0 as Misc
import WGTools.PropertyGrid 1.0
import WGTools.Utils 1.0

import "Settings.js" as Settings

// TODO: refactoring - implements fog edges via sliders !!!

FogMinimapDelegate {
	id: delegateRoot

	property var model // TODO: consider implement context property "model"
	anchors.centerIn: parent

	readonly property int offsetX: 100
	readonly property int offsetY: 25
	implicitWidth: root.width + offsetX * 2
	implicitHeight: root.height + offsetY * 2

	propertyData: model ? model.node.property : null

	enabled: propertyData && !propertyData.readonly

	enum EdgeType {
		Left,
		Right,
		Top,
		Bottom
	}

	enum RangeType {
		Min,
		Max
	}

	Item {
		id: root
		readonly property int pixelWidth: 200
		readonly property int pixelHeight: 200
		readonly property int maxEdgeSize: 300
		visible: map.status == Image.Ready

		x: delegateRoot.offsetX
		y: delegateRoot.offsetY

		readonly property int maxSceneWidth: delegateRoot.size.width + maxEdgeSize * 2
		readonly property int maxSceneHeight: delegateRoot.size.height + maxEdgeSize * 2

		function toPixelWidth(value) {
			return Utils.clamp(value / maxSceneWidth * pixelWidth , 0, pixelWidth)
		}

		function toPixelHeight(value) {
			return Utils.clamp(value / maxSceneHeight * pixelHeight, 0, pixelHeight)
		}

		function fromPixelWidth(value) {
			return value / pixelWidth * maxSceneWidth
		}

		function fromPixelHeight(value) {
			return value / pixelHeight * maxSceneHeight
		}

		width: pixelWidth
		height: pixelHeight

		Image {
			id: map
			anchors.centerIn: parent
			source: delegateRoot.path.length ? "file:///" + delegateRoot.path : ""
			width: root.toPixelWidth(delegateRoot.size.width)
			height: root.toPixelHeight(delegateRoot.size.height)
			opacity: 0.5
		}

		// edge enum
		readonly property int edgeLeft: 0
		readonly property int edgeRight: 1
		readonly property int edgeTop: 2
		readonly property int edgeBottom: 3

		// range enum
		readonly property int rangeMin: 0
		readonly property int rangeMax: 1

		Repeater {

			model: [{"edge" : root.edgeLeft,	"range" : root.rangeMin},
					{"edge" : root.edgeLeft,	"range" : root.rangeMax},
					{"edge" : root.edgeRight,	"range" : root.rangeMin},
					{"edge" : root.edgeRight,	"range" : root.rangeMax},
					{"edge" : root.edgeTop,		"range" : root.rangeMin},
					{"edge" : root.edgeTop,		"range" : root.rangeMax},
					{"edge" : root.edgeBottom,	"range" : root.rangeMin},
					{"edge" : root.edgeBottom,	"range" : root.rangeMax}]

			Rectangle {
				color: mouseArea.isEditing
					? _palette.color12
					: _palette.color1

				function isHorizontal() {
					return modelData.edge == root.edgeLeft ||
						modelData.edge == root.edgeRight
				}

				function getValue() {
					if (modelData.range == root.rangeMin) {
						if		(modelData.edge == root.edgeLeft) 	return delegateRoot.left.x
						else if	(modelData.edge == root.edgeRight) 	return delegateRoot.right.x
						else if	(modelData.edge == root.edgeTop) 	return delegateRoot.top.x
						else if	(modelData.edge == root.edgeBottom)	return delegateRoot.bottom.x
					}
					else if (modelData.range == root.rangeMax) {
						if		(modelData.edge == root.edgeLeft) 	return delegateRoot.left.y
						else if (modelData.edge == root.edgeRight) 	return delegateRoot.right.y
						else if (modelData.edge == root.edgeTop) 	return delegateRoot.top.y
						else if (modelData.edge == root.edgeBottom)	return delegateRoot.bottom.y
					}
				}

				function setValue(dX, dY, setterFlags = 0) {
					var deltaVal = isHorizontal()
						? root.fromPixelWidth(dX)
						: root.fromPixelHeight(dY)

					if (deltaVal == 0 && (setterFlags & )) {
						return
					}

					var x = (modelData.range == root.rangeMin)
						? deltaVal
						: 0
					var y = (modelData.range == root.rangeMax)
						? deltaVal
						: 0

					if		(modelData.edge == root.edgeLeft)	delegateRoot.setLeft(Qt.point(delegateRoot.left.x + x, delegateRoot.left.y + y), setterFlags)
					else if	(modelData.edge == root.edgeRight)	delegateRoot.setRight(Qt.point(delegateRoot.right.x + x, delegateRoot.right.y + y), setterFlags)
					else if	(modelData.edge == root.edgeTop)	delegateRoot.setTop(Qt.point(delegateRoot.top.x + x, delegateRoot.top.y + y), setterFlags)
					else if	(modelData.edge == root.edgeBottom)	delegateRoot.setBottom(Qt.point(delegateRoot.bottom.x + x, delegateRoot.bottom.y + y), setterFlags)
				}

				function getOffset() {
					var ret = root.maxEdgeSize

					if (modelData.edge == root.edgeRight) {
						ret += delegateRoot.size.width
					}
					else if (modelData.edge == root.edgeBottom) {
						ret += delegateRoot.size.height
					}

					return ret
				}

				x: isHorizontal()	? root.toPixelWidth(getValue() + getOffset())	: parent.width / 2 - width / 2
				y: !isHorizontal()	? root.toPixelHeight(getValue() + getOffset())	: parent.height / 2 - height / 2

				readonly property int lineWidth: 2
				width : isHorizontal() ? lineWidth : root.pixelHeight / 2
				height : !isHorizontal() ? lineWidth : root.pixelWidth / 2

				Misc.Text {
					text: parent.getValue().toFixed(2)

					x: !parent.isHorizontal()
						? parent.width / 2 - width / 2
						: modelData.range == root.rangeMin
							? -35
							: 3
					y: parent.isHorizontal()
						? parent.height / 2 - height / 2
						: modelData.range == root.rangeMin
							? -15
							: 3
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
						parent.setValue(pos.x, pos.y)
					}

					onPositionChanged: {
						if (isEditing) {
							if (!pressed) {
								stopEdit()
								return
							}
							var pos = mapToItem(parent, mouseX, mouseY)
							parent.setValue(pos.x, pos.y, IValueData.TRANSIENT)
						}
					}
				}
			}
		}
	}
}
