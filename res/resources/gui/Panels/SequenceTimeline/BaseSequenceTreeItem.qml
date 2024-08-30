import QtQuick 2.7

import WGTools.AnimSequences 1.0
import WGTools.Controls 2.0 as Controls
import WGTools.Misc 1.0 as Misc

import "Constants.js" as Constants

Rectangle {
	id: itemRoot
	Accessible.name: itemData.label == "Root"
					? styleData.context.playbackController.attachedResourceName
					: itemData.label
	property bool _selected: styleData.selectionModel
		? styleData.selectionModel.isSelected(styleData.index)
		: false

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

			Controls.Button {
				id: expandButton
				Accessible.name: "Expand"

				width: 25
				height: Constants.seqTreeItemHeight
				visible: (itemData.isExpandable && hasChildren) 
					|| (itemData.keyType == SequenceItemTypes.CurveKey && itemData.curveContainer != null)
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
					if (isCurveTrack())
						styleData.curveEditorEnabled = !styleData.curveEditorEnabled
					else {
						if (styleData.expanded)
							styleData.view.collapse(styleData.index)
						else
							styleData.view.expand(styleData.index)
					}
				}

				function getRotation() {
					if (isCurveTrack()) {
						return styleData.curveEditorEnabled ? 90 : 0
					}
					else {
						return styleData.expanded ? 90 : 0
					}
				}

				function isCurveTrack() {
					return itemData.itemType == SequenceItemTypes.CompoundTrack
				}
			}

			Rectangle {
				id: iconFrame
				Accessible.name: "Icon"

				width: Constants.seqTreeIconFrameWidth
				height: Constants.seqTreeIconFrameHeight
				color: itemRoot.color

				anchors.left : expandButton.right

				Image {
					source: itemData.icon
					sourceSize.width: Constants.seqTreeIconWidth
					sourceSize.height: Constants.seqTreeIconHeight

					anchors.verticalCenter: iconFrame.verticalCenter
				}
			}

			Misc.Text {
				id: entryLabel
				Accessible.name: "Text"

				color: "white"
				text: itemData.label == "Root"
					? styleData.context.playbackController.attachedResourceName
					: itemData.label
				
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
