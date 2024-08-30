import QtQuick 2.7
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.0

import SeqTreeItemTypes 1.0

import "Constants.js" as Constants
import "Debug"

Rectangle {
	id: itemRoot
	property bool _selected: styleData.selectionModel.isSelected(styleData.index)

	color: _selected ? Constants.selectionColor : (index % 2 ? Constants.seqTreeEvenItemColor : Constants.seqTreeOddItemColor)
	height: Constants.seqTreeItemHeight

	Rectangle {
		id: selectionFrame

		anchors.fill: parent
		anchors.rightMargin: 1
		color: "transparent"

		z: 100

		border.width: 2
		border.color: "transparent"

		MouseArea {
			anchors.fill: parent

			hoverEnabled: true
			propagateComposedEvents: true

			onPressed: mouse.accepted = false
			onReleased: mouse.accepted = false
			onWheel: wheel.accepted = false
			onEntered: selectionFrame.border.color = Constants.selectionColor
			onExited: selectionFrame.border.color = "transparent"
		}
	}

	Connections {
		target: styleData.selectionModel
		ignoreUnknownSignals: false
		onSelectionChanged : {
			itemRoot._selected = styleData.selectionModel.isSelected(styleData.index)
		}
	}

	Loader {
		id: leaf

		anchors.left: parent.left
		anchors.leftMargin: itemDepth * Constants.seqTreeDepthPadding
		anchors.right: parent.right
		height: Constants.seqTreeItemHeight

		clip: true

		sourceComponent: Item {
			id: rectCopmponent

			Button {
				id: expandButton

				width: 25
				height: Constants.seqTreeItemHeight
				visible: (itemExpandable && hasChildren) || 
					(itemKeyTrackType == SeqTreeItemTypes.CurveKey && itemCurveContainer != null)
				rotation: getRotation()

				focusPolicy: Qt.NoFocus
				
				background: Item {
					implicitWidth: 25
					implicitHeight: 25
				}

				contentItem: Image {
					source: Constants.iconCollapseExpand

					fillMode: Image.Pad

					verticalAlignment: Image.AlignVCenter

					sourceSize.width: 6
					sourceSize.height: 12
				}

				onClicked: {
					if (itemKeyTrackType == SeqTreeItemTypes.CurveKey) {
						styleData.curveEditorEnabled = !styleData.curveEditorEnabled
					}
					else {
						if (styleData.expanded) {
							styleData.view.collapse(styleData.index)
						}
						else {
							styleData.view.expand(styleData.index)
						}
					}
				}

				function getRotation() {
					if (itemKeyTrackType == SeqTreeItemTypes.CurveKey) {
						return styleData.curveEditorEnabled ? 90 : 0
					}
					else {
						return styleData.expanded ? 90 : 0
					}
				}
			}

			Rectangle {
				id: iconFrame

				width: Constants.seqTreeIconFrameWidth
				height: Constants.seqTreeIconFrameHeight
				color: itemRoot.color

				anchors.left : expandButton.right

				Image {
					source: itemIconPath
					sourceSize.width: Constants.seqTreeIconWidth
					sourceSize.height: Constants.seqTreeIconHeight

					anchors.verticalCenter: iconFrame.verticalCenter
				}
			}

			Text {
				id: entryLabel

				color: "white"
				text: model.itemLabel == "Root" ? "Root (" + styleData.context.modelName + ")" : model.itemLabel
				
				font.pixelSize: Constants.fontSize
				font.family: Constants.proximaRg
				font.bold: true

				anchors.left : iconFrame.right
				anchors.horizontalCenter: expandButton.horizontalCenter
				anchors.verticalCenter: expandButton.verticalCenter
			}
		}
	}
}
