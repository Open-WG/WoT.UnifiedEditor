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

	property bool _renamingActive : false

	on_SelectedChanged: {
		if (_selected === false)
			_renamingActive = false
	}

	focus: _selected

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
			onReleased: mouse.accepted = true
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

			if (itemRoot._selected)
			{
				itemRoot.forceActiveFocus()
			}
		}
	}

	Connections {
		target: styleData.context
		ignoreUnknownSignals: false
		onRenamingNodeChanged: {
			if (itemData.canBeRenamed)
			{
				itemRoot.forceActiveFocus()
				itemRoot._renamingActive = true
			}
		}
		enabled: _selected
	} 

	// Ensure that we get escape key press events first.
	Keys.onShortcutOverride: event.accepted = (//event.key === Qt.Key_F2 || 
		event.key === Qt.Key_Escape)
	// Keys.onPressed: {
	// 	if (event.key == Qt.Key_F2) {
	// 		if (itemData.canBeRenamed)
	// 		{
	// 			itemRoot._renamingActive = true
	// 		}
	// 		event.accepted = true
	// 	}
	// }
	Keys.onEscapePressed: {
		itemRoot._renamingActive = false

		event.accepted = true
	}

	Loader {
		id: leaf

		anchors.left: parent.left
		anchors.leftMargin: itemDepth * Constants.seqTreeDepthPadding
		anchors.right: parent.right
		height: Constants.seqTreeItemHeight

		clip: true
		focus: true

		sourceComponent: Item {
			id: rectComponent

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
					else
						if (styleData.expanded)
							styleData.view.collapse(styleData.index)
						else
							styleData.view.expand(styleData.index)
				}

				function getRotation() {
					if (isCurveTrack())
						return styleData.curveEditorEnabled ? 90 : 0
					else
						return styleData.expanded ? 90 : 0
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

				enabled: !itemRoot._renamingActive
				visible: !itemRoot._renamingActive
				Accessible.name: "Text"

				color: "white"
				text: itemData.label == "Root" ? styleData.context.playbackController.attachedResourceName : itemData.label
				
				font.pixelSize: Constants.fontSize
				font.family: Constants.proximaRg
				font.bold: true

				anchors.left : iconFrame.right
				anchors.horizontalCenter: expandButton.horizontalCenter
				anchors.verticalCenter: expandButton.verticalCenter

				onTextChanged: textRenamingArea.text = text
			}

			//Controls.TextArea {
			TextInput{
				id: textRenamingArea
				
				visible: itemRoot._renamingActive
				//placeholderText: entryLabel.text
				text: entryLabel.text
				color: "white"
				height: Constants.seqTreeItemHeight - selectionFrame.border.width * 2
				
				font.pixelSize: Constants.fontSize
				font.family: Constants.proximaRg
				font.bold: true

				anchors.left : entryLabel.left
				anchors.top : entryLabel.top

				onVisibleChanged: {
					text = entryLabel.text
					selectAll()
					forceActiveFocus()
				}

				onEditingFinished: {
					if (itemData && itemRoot._renamingActive && itemData.nameIsValid(text))
					{
						itemData.setObjectName(text)

						itemRoot._renamingActive = false;
					}
					else
						color = "red"
				}

				Behavior on color {
					SequentialAnimation {
						loops: 1
						ColorAnimation { from: "white"; to: "red"; duration: 300 }
						ColorAnimation { from: "red"; to: "white";  duration: 300 }

						onRunningChanged: {
							if (running == false)
								itemRoot._renamingActive = false;
						}
					}
				}
			}
		}
	}
}
