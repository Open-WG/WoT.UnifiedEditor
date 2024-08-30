import QtQuick 2.7
import QtQml.Models 2.2
import QtQuick.Controls 2.3
import WGTools.Controls 2.0 as Controls

import "Details/Graph" as GraphDetails

Rectangle {
	id: root

	property Component edgeDelegate: GraphDetails.Edge {}
	property Component vertexDelegate: GraphDetails.Vertex {}

	property var graphModel: null
	property var selectionModel: null

	property var vertexRequestor: null
	property var edgeRequestor: null
	property var controller: null

	color: _palette.color8

	clip: true

	MouseArea {
		id: rootMA

		anchors.fill: parent

		acceptedButtons: Qt.RightButton | Qt.LeftButton | Qt.MiddleButton
		hoverEnabled: true
		propagateComposedEvents:true

		drag.target: primitiveWrapper
		drag.threshold: 0

		cursorShape: drag.active ? Qt.ClosedHandCursor : Qt.ArrowCursor

		onPressed: {
			if (mouse.button != Qt.MiddleButton)
				drag.target = null
			else
				drag.target = primitiveWrapper
		}

		onClicked: {
			if (mouse.button == Qt.RightButton) {
				popup.open()
				popup.x = mouse.x
				popup.y = mouse.y
			}

			stubEdge.visible = false
			root.focus = true
		}

		onPositionChanged: {
			if (stubEdge.visible) {
				stubEdge.styleData.toX = mouse.x - primitiveWrapper.x
				stubEdge.styleData.toY = mouse.y - primitiveWrapper.y
			}
		}
	}

	Item {
		id: primitiveWrapper

		anchors.centerIn: parent

		Connections {
			target: rootMA.drag
			onActiveChanged: primitiveWrapper.anchors.centerIn = undefined
		}

		Connections {
			target: controller
			onStateMachineLoaded: primitiveWrapper.anchors.centerIn = root
		}

		Repeater {
			id: rootRepeater
			property real selectionZ: 0

			model: DelegateModel {
				id: rootDelegateModel

				model: graphModel

				delegate: Item {
					id: container
					z: index
					
					property var delegateName: index != -1 ? "Details/Graph/" + ["Edge", "Vertex"][index] + "Delegate.qml" : ""

					anchors.fill: parent

					Repeater {
						model: DelegateModel {
							id: delegateModel

							model: index == -1 ? null : graphModel
							rootIndex: delegateModel.modelIndex(index)

							delegate: Loader {
								active: model && model.itemData ? true : false
								source: container.delegateName
								z: 0

								property var _selfIndex: delegateModel.modelIndex(index)
								property var _selected: checkSelection()

								function checkSelection() {
									return selectionModel.isSelected(_selfIndex)
								}

								Connections {
									target: selectionModel
									onSelectionChanged: _selected = Qt.binding(checkSelection)
								}

								on_SelectedChanged: {
									if (_selected) {
										rootRepeater.selectionZ += 0.000001
										z = rootRepeater.selectionZ
									}
								}
							}
						}
					}
				}
			}
		}

		GraphDetails.TwoVertexEdge {
			id: stubEdge

			property var index: 0
			property var model: null

			centerOffset: 0

			visible: false

			property var fromVertexIndex: null
			property QtObject styleData: QtObject {
				property var fromX: 0
				property var fromY: 0
				property var toX: 0
				property var toY: 0
				property var selectionModel: null
			}
		}
	}

	Controls.Menu {
		id: popup

		modal: true

		Repeater {
			model: vertexRequestor

			Controls.MenuItem {
				height: 20

				text: itemLabel

				onTriggered: {
					vertexRequestor.requestVertexCreation(itemID, popup.x - primitiveWrapper.x,
						popup.y - primitiveWrapper.y)
				}
			}
		}
	}
}
