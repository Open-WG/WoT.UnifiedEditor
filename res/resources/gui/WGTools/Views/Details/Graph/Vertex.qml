import QtQuick 2.7
import QtQml.Models 2.2
import QtQuick.Controls 2.3
import WGTools.Misc 1.0 as Misc
import WGTools.Controls 2.0 as Controls

Rectangle {
	id: vertex

	signal edgeCreationStarted()
	signal leftClicked()

	property var selfModelIndex: styleData.selfModelIndex
	property var selected: styleData.selectionModel.isSelected(selfModelIndex)
	property var textColor: "white"

	x: model ? getComp(model.itemData.centerX, width) : 0
	y: model ? getComp(model.itemData.centerY, height) : 0

	width: model ? model.itemData.width : 0
	height: model ? model.itemData.height : 0

	color: "#1a1a1a"
	radius: 3

	border.color: selected ? "#0093ff" : "transparent"
	border.width: 3

	Misc.Text {
		anchors.centerIn: parent

		width: vertex.width - 20

		color: vertex.textColor

		elide: Text.ElideRight
		text: model ? model.itemData.label : ""
		horizontalAlignment: Text.AlignHCenter
	}

	MouseArea {
		id: vertexMA

		anchors.fill: parent

		acceptedButtons: Qt.LeftButton | Qt.RightButton
		cursorShape: drag.active ? Qt.ClosedHandCursor : Qt.ArrowCursor
		hoverEnabled: false
		propagateComposedEvents:true

		drag.target: vertex
		drag.threshold: 1

		onPressed: {
			forceActiveFocus()
			styleData.selectionModel.select(selfModelIndex, ItemSelectionModel.ClearAndSelect)

			if (mouse.button == Qt.LeftButton) {
				leftClicked()
				drag.target = vertex
			}
			else {
				drag.target = null
			}
		}

		onClicked: {
			if (mouse.button == Qt.RightButton) {
				popup.open()
				popup.x = mouse.x
				popup.y = mouse.y
			}
			else if (mouse.button == Qt.LeftButton) {
				leftClicked()
			}
		}

		Connections {
			target: styleData.selectionModel
			ignoreUnknownSignals: false
			onSelectionChanged: {
				var newState = styleData.selectionModel.isSelected(selfModelIndex);
				if (newState != vertex.selected)
					vertex.selected = newState
			}
		}

		Connections {
			target: vertexMA.drag
			ignoreUnknownSignals: false
			onActiveChanged: {
				if (vertexMA.drag.active) {
					model.itemData.dragStarted(model.itemData.centerX, model.itemData.centerY)
				}
				else {
					model.itemData.dragStopped(model.itemData.centerX, model.itemData.centerY)
				}
			}
		}
	}

	Controls.Menu {
		id: popup

		modal: true

		Repeater {
			model: styleData.edgeRequestor

			Controls.MenuItem {
				height: 20

				text: itemLabel

				onTriggered: {
					edgeCreationStarted()
				}
			}
		}

		Controls.MenuItem {
			height: 20

			text: "Set As Default"

			onTriggered: {
				model.itemData.isStartingNode = true
			}
		}
	}

	onXChanged: {
		if (model)
			model.itemData.centerX = getCenterComp(x, width)
	}

	onYChanged: {
		if (model)
			model.itemData.centerY = getCenterComp(y, height)
	}

	onZChanged: {
		if (model)
			model.itemData.centerZ = z
	}

	function getComp(centerComp, side) {
		return centerComp - side / 2
	}

	function getCenterComp(currentCompVal, side) {
		return currentCompVal + side / 2
	}
}
