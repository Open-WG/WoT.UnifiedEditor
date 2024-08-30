import QtQuick 2.11
import QtQml.StateMachine 1.11 as SM

import WGTools.Controls 2.0 as Controls

import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.DropAreas 1.0

import "Details" as Details

Rectangle {
	id: itemRoot

	Accessible.name: itemData.label == "Root"
		? styleData.context.playbackController.attachedResourceName
		: itemData.label

	property bool _selected: styleData.selectionModel
		? styleData.selectionModel.isSelected(styleData.index)
		: false

	property bool _renamingActive: false
	property bool dragActive: ma.drag.active

	Drag.dragType: Drag.Automatic
	// This can be used to get event info for drag starts and 
	// stops instead of onDragStarted/onDragFinished, since
	// those will neer be called if we don't use Drag.active
	onDragActiveChanged: {
		if (dragActive) {
			opacity = 0.7
			Drag.start()

			if (!rootSequenceTree.selectionDraggable)
				styleData.context.setForbiddenCursor()
		} else {
			styleData.context.resetCursor()
			Drag.drop();
			opacity = 1
		}
	}

	on_SelectedChanged: {
		if (_selected === false)
			_renamingActive = false
	}

	color: _selected ? Constants.selectionColor : (index % 2 ? Constants.seqTreeEvenItemColor : Constants.seqTreeOddItemColor)
	height: Constants.seqTreeItemHeight
	focus: _selected

	Rectangle {
		id: selectionFrame
		color: "transparent"
		z: 100

		anchors.fill: parent
		anchors.rightMargin: 1

		border.width: 2
		border.color: "transparent"
	}

	// We want to start dragging, but don't want any movement of item
	// so just use this transparent stub item as drag.target instead
	Rectangle {
		id: stub
		color: "transparent"
		anchors.fill: parent
	}

	MouseArea {
		id: ma
		hoverEnabled: true
		propagateComposedEvents: true

		onWheel: wheel.accepted = false
		onEntered: selectionFrame.border.color = Constants.selectionColor
		onExited: selectionFrame.border.color = "transparent"

		anchors.fill: parent

		drag.target: rootSequenceTree.selectionDraggable ? itemRoot : stub
		drag.axis: draggingEnabled ? Drag.YAxis : Drag.None
	}

	Connections {
		target: styleData.selectionModel
		onSelectionChanged: {
			itemRoot._selected = styleData.selectionModel.isSelected(styleData.index)

			if (itemRoot._selected) {
				itemRoot.forceActiveFocus()
			}
		}
	}

	Connections {
		enabled: _selected
		target: styleData.context
		ignoreUnknownSignals: true
		onRenamingNodeChanged: {
			if (itemData.canBeRenamed) {
				itemRoot._renamingActive = true
			}
		}
	} 

	Keys.onShortcutOverride: event.accepted = (
		event.key === Qt.Key_Escape)

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
			Details.ExpandButton {
				id: expandButton
			}

			Details.Icon {
				id: iconFrame
				color: itemRoot.color
				source: itemData.icon

				anchors.left: expandButton.right
			}

			Details.Label {
				id: entryLabel
				enabled: !itemRoot._renamingActive
				visible: enabled
				text: itemData.label == "Root" ? styleData.context.playbackController.attachedResourceName : itemData.label

				anchors.left: iconFrame.right
				anchors.verticalCenter: expandButton.verticalCenter

				onTextChanged: textRenamingArea.text = text
			}

			Details.NameEdit {
				id: textRenamingArea
				visible: itemRoot._renamingActive
				text: entryLabel.text
				
				anchors.left: entryLabel.left
				anchors.verticalCenter: entryLabel.verticalCenter

				onVisibleChanged: {
					text = entryLabel.text
					selectAll()
					forceActiveFocus()
				}

				onEditingFinished: {
					if (itemData) {
						var newName = text.trim()

						if (itemRoot._renamingActive && itemData.nameIsValid(newName)) {
							itemData.setObjectName(newName)
							itemRoot._renamingActive = false;
						} else if (itemRoot._renamingActive) {
							alert()
						}
					}
				}

				onAlertFinished: {
					itemRoot._renamingActive = false;
				}
			}
		}
	}

	TreeItemDropArea {
		id: topDropArea
		visible: rootSequenceTree.draggingItem != null && rootSequenceTree.draggingItem != itemRoot
		topSide: true
	}

	TreeItemDropArea {
		id: bottomDropArea
		anchors.top: topDropArea.bottom
		visible: topDropArea.visible
		topSide: false
	}

	SM.StateMachine {
		initialState: idleState
		running: true

		SM.State {
			id: idleState

			SM.SignalTransition { targetState: draggingState; signal: ma.drag.activeChanged; guard: ma.drag.active}
		}

		SM.State {
			id: draggingState

			property var oldParent
			property real oldY

			onEntered: {
				oldY = itemRoot.y
				if (rootSequenceTree.selectionDraggable)
				{
					oldParent = itemRoot.parent
					itemRoot.parent = rootSequenceTree
					rootSequenceTree.draggingItem = itemRoot
				}
			}

			onExited: {
				if (rootSequenceTree.selectionDraggable)
					itemRoot.parent = oldParent

				itemRoot.y = oldY
				rootSequenceTree.draggingItem = null
			}

			SM.SignalTransition { targetState: idleState; signal: ma.drag.activeChanged; guard: !ma.drag.active}
		}
	}
}
