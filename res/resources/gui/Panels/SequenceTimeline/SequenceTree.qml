import QtQuick 2.7
import QtQml.Models 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import QtQuick.Window 2.2
import QtQuick.Controls 1.4 as Controls14

import WGTools.AnimSequences 1.0 as Sequences
import WGTools.Utils.QMLCursor 1.0 as QMLCursor

import "Constants.js" as Constants
import "Menus"
import "Buttons"

FocusScope {
	id: rootSequenceTree

	signal moveKey(var index, real newStartTime)
	signal zoomShortcutActivated(real delta)

	property real treeColumnWidth: 0
	property real spacing: 0

	readonly property alias adapter: modelAdapter
	property alias model: modelAdapter.model
	property alias timelineViewID: timelineView
	property var rootContext: null
	property var selectionModel: null
	property var timelineController: null

	property var containerTopZValue: 0

	property Component rowDelegate

	implicitHeight: 300

	function isExpanded(index) {
		return modelAdapter.isExpanded(styleData.index)
	}

	function expand(index) {
		modelAdapter.expand(index)
	}

	function collapse(index) {
		modelAdapter.collapse(index)
	}

	Sequences.SequenceModelAdapter {
		id: modelAdapter
	}

	Rectangle {
		color: _palette.color8
		anchors.fill: parent
	}

	Column {
		id: rowsLayout
		width: parent.width
		spacing: columnsLayout.spacing
		y: -flickable.contentY

		Repeater {
			id: rowsRepeater
			model: ListModel { id: rowsModel }
			delegate: Loader {
				width: parent.width
				height: model.item.height
				sourceComponent: rootSequenceTree.rowDelegate

				property QtObject styleData: QtObject {
					readonly property bool alternative: index % 2
				}
			}
		}
	}

	TimelineView {
		id: timelineView
		scaleController: rootSequenceTree.timelineController
		model: rootSequenceTree.timelineController 
			? rootSequenceTree.timelineController.scaleModel
			: null
		context: rootContext

		anchors.fill: parent
		anchors.leftMargin: rootSequenceTree.treeColumnWidth + rootSequenceTree.spacing
	}

	Flickable {
		id: flickable

		enabled: rootContext
			? rootContext.sequenceOpened && rootContext.modelSelected
			: false

		contentWidth: width
		contentHeight: columnsLayout.height
		focus: true

		anchors.fill: parent
		anchors.leftMargin: rootSequenceTree.spacing
		interactive: true
		flickableDirection: Flickable.VerticalFlick
		maximumFlickVelocity: 400

		function resetSelectionBox() {
			selectionBox.width = 0
			selectionBox.height = 0
			selectionBox.x = 0
			selectionBox.y = 0
		}

		ScrollBar.vertical: ScrollBar { 
			id: flickableScrollBar
		}

		MouseArea {
			id: treeMA

			property var _moving: false
			property real _initialY: 0
			property real _prevClickY: 0

			acceptedButtons: Qt.LeftButton | Qt.MiddleButton

			propagateComposedEvents: true
			hoverEnabled: true
			preventStealing: true

			anchors.left: parent.left
			anchors.right: flickableMA.left

			y: flickable.contentY
			z: _moving ? 1000 : 0

			height: flickable.height

			onPressed: {
				_moving = true

				_initialY = _prevClickY = mouse.y

				cursorShape = Qt.ClosedHandCursor
			}

			onReleased: {
				_prevClickY = 0

				cursorShape = Qt.ArrowCursor

				flickable.flick(0.0, 10.0)

				_moving = false
			}

			onPositionChanged: {
				if (_moving) {
					var deltaY = mouse.y - _prevClickY
					_prevClickY = mouse.y

					flickable.contentY -= deltaY
				}
			}

			onWheel: {
				wheel.accepted = false
			}
		}

		MouseArea {
			id: flickableMA

			property bool moving: false
			property real prevClickX: 0
			property real prevClickY: 0
			property real initialX: 0
			property real initialY: 0

			z: moving ? 1000 : 0
			y: flickable.contentY
			height: flickable.height
			width: timelineView.width
			anchors.right: parent.right
			
			acceptedButtons: Qt.LeftButton | Qt.MidButton
			propagateComposedEvents: true
			hoverEnabled: true
			preventStealing: true

			onWheel: {
				timelineView.scaleController.zoom(wheel.angleDelta.y / 2, wheel.x)
			}

			Connections {
				target: rootSequenceTree
				onZoomShortcutActivated: {
					var pos = flickableMA.containsMouse ? flickableMA.mouseX : flickableMA.width / 2
					timelineView.scaleController.zoom(delta, pos)
				}
			}

			Sequences.SelectionHelper {
				id: selectionHelper
				model: rootSequenceTree.selectionModel
			}

			onClicked: {
				forceActiveFocus()
			}

			onPressed: {
				moving = true
				flickable.resetSelectionBox()

				initialX = prevClickX = mouse.x
				initialY = prevClickY = mouse.y

				if (mouse.button == Qt.MidButton)
					cursorShape = Qt.ClosedHandCursor
				else
					selectionBox.visible = true

				mouse.accepted = true
			}

			onReleased: {
				if (mouse.button == Qt.MidButton) {
					prevClickX = 0
					prevClickY = 0

					cursorShape = Qt.ArrowCursor

					flickable.flick(0.0, 10.0)
				}

				moving = false
				if (!(mouse.modifiers & Qt.ControlModifier))
					rootSequenceTree.selectionModel.clearSelection()
				
				selectionBox.visible = false
				for (var i = 0; i < leavesRepeater.count; ++i)
					leavesRepeater.itemAt(i).selectItems(selectionModel, selectionBox, selectionHelper)

				selectionHelper.flush(ItemSelectionModel.Select)
			}

			onPositionChanged: {
				if (moving) {
					if (mouse.buttons & Qt.MidButton) {
						cursorShape = Qt.ClosedHandCursor

						var deltaX = mouse.x - prevClickX
						prevClickX = mouse.x

						timelineView.scaleController.move(deltaX)

						var deltaY = mouse.y - prevClickY
						prevClickY = mouse.y

						flickable.contentY -= deltaY
					}
					else if (mouse.buttons & Qt.LeftButton) {
						var mx = mouse.x
						var my = mouse.y

						if (mx > flickableMA.width)
							mx = flickableMA.width
						else if (mx < 0)
							mx = 0

						if (my > flickableMA.height)
							my = flickableMA.height
						else if (my < 0)
							my = 0

						var newWidth = mx - initialX
						var newHeight = my - initialY

						selectionBox.width = newWidth
						selectionBox.height = newHeight

						if (newWidth > 0) {
							selectionBox.width = newWidth
							selectionBox.x = initialX
						}
						else {
							selectionBox.width = -newWidth
							selectionBox.x = initialX + newWidth
						}

						if (newHeight > 0) {
							selectionBox.height = newHeight
							selectionBox.y = initialY
						}
						else {
							selectionBox.height = -newHeight
							selectionBox.y = initialY + newHeight
						}
					}
				}
			}
		}

		Column {
			id: columnsLayout
			objectName: "sequenceTreeItems"
			width: parent.width
			spacing: 0

			Repeater {
				id: leavesRepeater

				onItemAdded: {
					if (item.visible)
						rowsModel.insert(index, {"item": item})
				}

				onItemRemoved: {
					if (item.visible)
						rowsModel.remove(index)
				}

				model: DelegateModel {
					id: delegateModel

					model: modelAdapter

					delegate: SequenceTreeDelegate {
						treeColumnWidth: rootSequenceTree.treeColumnWidth
						sourceModelAdapter: modelAdapter
						thisDelegateModel: delegateModel
						selectionModel: rootSequenceTree.selectionModel
						viewOwner : flickable
					}
				}
			}

			//Fake item to correct scrolling over the Add Sequence Object Button
			Item {
				height: Constants.seqTreeItemHeight

				width: 1
			}
		}
	}

	Item {
		id: selectionBoxArea

		anchors.fill: timelineView

		SelectionBox {
			id: selectionBox

			visible: false
		}
	}

	TimelineButton {
		id: addObjButton
		objectName: "addObjButton"

		anchors.bottom : parent.bottom
		anchors.right: timelineView.left
		anchors.left: parent.left
		anchors.leftMargin: 9
		anchors.rightMargin: anchors.leftMargin
		anchors.bottomMargin: 5

		padding: 4

		enabled: context.sequenceOpened
		visible: context.seqObjectFactory && context.seqObjectFactory.availableObjects
			&& context.seqObjectFactory.availableObjects.hasItems

		text: "Add Sequence Object"
		iconImage: Constants.iconAddButton

		onClicked: {
			if (popup.visible)
				popup.close()
			else {
				popup.open()
			}
		}
	}

	AddSeqObjectPopup {
		id: popup

		width: addObjButton.width
		x: addObjButton.x
		y: height

		model: context.seqObjectFactory && context.seqObjectFactory.availableObjects

		Component.onCompleted: y = Qt.binding(function() { return addObjButton.y - popup.height })
	}

	Connections {
		target: context.timelineActionManager
		onDeleteItem: context.sequenceModel.deleteItems(context.selectionModel.selection)
		onAddKeyToSelection: context.sequenceModel.addKeyToSelection(context.selectionModel.selection)
	}
}
