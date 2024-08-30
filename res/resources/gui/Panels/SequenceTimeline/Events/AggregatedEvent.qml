import QtQuick 2.11
import QtQml.Models 2.2

import WGTools.AnimSequences 1.0
import WGTools.Misc 1.0 as Misc
import WGTools.Controls 2.0 as Controls

import "../Constants.js" as Constants

Item {
	id: root

	property alias mouseArea: eventFrame
	property var model
	property var modelIndex
	property var viewID
	
	anchors.alignWhenCentered: false

	x: getPosition()
	function getPosition() {
		return Math.round(context.timelineController.fromSecondsToScale(
								itemData.time))
	}

	function getSourceIndex() {
		var childIndex = root.model.index(0, 0, root.modelIndex)
			return model.getData(childIndex).sourceIndex
	}
	Item {
		width: 1
		height: root.height

		SelectionHelper {
			id: selectionHelper

			model: context.eventSelectionModel
		}

		Rectangle {
			id: eventFrame
			color: "transparent"
			width: eventItem.width * 1.5
			height: root.height
			
			anchors.alignWhenCentered: true
			anchors.centerIn: parent

			MouseArea {
				anchors.fill: parent
				acceptedButtons: Qt.RightButton

				onClicked: {
					if (itemData.childCount > 1) {
						popupLoader.sourceComponent = popupComp
					}
				}

				Loader {
					id: popupLoader
				}

				Component {
					id: popupComp
					Controls.Menu {
						id: childrenPopup
						x: eventFrame.width / 2
						y: eventFrame.height / 2
						visible: true
						Repeater {
							model: DelegateModel {
								model: root.model
								rootIndex: root.modelIndex

								delegate: Controls.MenuItem {
									property var __item: context.sequenceEventModel.getData(itemData.sourceIndex)
									text: __item.name

									onTriggered: {
										selectionHelper.push(itemData.sourceIndex)
										selectionHelper.flush(ItemSelectionModel.ClearAndSelect)
									}
								}
							}
						}

						onClosed: popupLoader.sourceComponent = null
					}
				}
			}
		}

		Rectangle {
			id: eventItem

			property var __selected: isSelected()

			anchors.alignWhenCentered: true
			anchors.centerIn: parent

			width: __selected ? Constants.seqKeySelectedSize : Constants.seqKeySize
			height: width
			rotation: 45
			antialiasing: true
			color: "transparent"
			border.width: __selected ? 2 : 1
			border.color: __selected
				? Constants.seqKeySelectedBorderColor
				: Constants.seqKeyColor

			function isSelected() {
				var numRows = root.model.rowCount(root.modelIndex)
				for (var i = 0; i < numRows; ++i) {
					var childIndex = root.model.index(i, 0, root.modelIndex)
					if (context.eventSelectionModel.isSelected(
						root.model.getData(childIndex).sourceIndex))
						return true
				}

				return false
			}

			Rectangle {
				anchors.centerIn: parent
				visible: itemData.childCount > 1
				width: parent.width / 3
				height: width
				color: parent.border.color
			}

			Connections {
				target: context.eventSelectionModel
				ignoreUnknownSignals: false
				onSelectionChanged: eventItem.__selected = eventItem.isSelected()
			}

			Connections {
				target: itemData
				onChildCountChanged: eventItem.__selected = eventItem.isSelected()
			}
		}
	}
	Connections {
		target: context.timelineController
		ignoreUnknownSignals: false
		onScaleChanged: root.x = Qt.binding(getPosition)
	}
}
