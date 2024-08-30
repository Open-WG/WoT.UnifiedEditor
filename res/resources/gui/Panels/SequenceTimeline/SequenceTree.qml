import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.4
import QtQml.Models 2.11
import WGTools.AnimSequences 1.0 as Sequences
import Panels.SequenceTimeline.Tree 1.0
import Panels.SequenceTimeline.Timeline 1.0
import Panels.SequenceTimeline.CurveEditor 1.0
import "Constants.js" as Constants

FocusScope {
	id: rootSequenceTree

	readonly property alias adapter: modelAdapter
	property alias model: modelAdapter.model

	property alias timelineViewID: timelineForeground // TODO: delete
	property alias curvesView: curvesView
	property alias curveActions: curveActions

	property var rootContext: null
	property var selectionModel: null
	property var containerTopZValue: 0

	property bool draggingEnabled: false
	property bool selectionDraggable: false
	property var draggingItem: null

	implicitHeight: 300
	clip: true

	function expand(index) {
		modelAdapter.expand(index)
	}

	function collapse(index) {
		modelAdapter.collapse(index)
	}

	function isExpanded(index){
		return modelAdapter.isExpanded(styleData.index)
	}

	function zoom(delta) {
		var pos = context.timelineController.fromSecondsToScale(context.sequenceModel.sequenceDuration / 2)
		zoomTo(delta, pos)
	}

	function zoomToCursor(delta) {
		var pos = timelineCursor.getPosition()
		zoomTo(delta, pos)
	}

	function zoomTo(delta, position) {
		context.timelineController.zoom(delta, position)
	}

	Connections {
		target: context.timelineActionManager
		onAddKeyToSelection: context.sequenceModel.addKeyToSelection(context.selectionModel.selection)
		onZoomIn: rootSequenceTree.zoom(120)
		onZoomOut: rootSequenceTree.zoom(-120)
		onZoomInToTimeCursor: rootSequenceTree.zoomToCursor(120)
		onZoomOutFromTimeCursor: rootSequenceTree.zoomToCursor(-120)
	}

	signal updateHeihgts()

	Connections {
		target: treeView.repeater
		onCountChanged: Qt.callLater(function() {rootSequenceTree.updateHeihgts()})
	}

	Connections {
        target: context
        enabled: !context.curveMode
        onCurveModeChanged: Qt.callLater(function() {rootSequenceTree.updateHeihgts()})
    }

	Connections {
		target: rootSequenceTree.selectionModel
		ignoreUnknownSignals: false
		enabled: draggingEnabled
		onSelectionChanged: {
			selectionDraggable = context.isSelectionDraggable()
		}
	}

	CurveActions {
		id: curveActions
		sequenceModel: rootSequenceTree.model
		selectionModel: rootSequenceTree.selectionModel
	}

	Flickable {
		id: flickable
		width: parent.width
		height: parent.height
		contentWidth: width
		contentHeight: treeView.height
		flickableDirection: Flickable.VerticalFlick
		maximumFlickVelocity: 400
		interactive: true
		enabled: context.sequenceOpened && context.modelSelected
		focus: true
		clip: true

		ScrollBar.vertical: ScrollBar {}
		Sequences.SequenceModelAdapter { id: modelAdapter }

		RowLayout {
			width: flickable.width
			height: Math.max(flickable.contentHeight, flickable.height)
			spacing: timelineSplitter.width

			/******************************************************************
			 * tree
			 */
			Item {
				Layout.preferredWidth: timelineSplitter.x
				Layout.fillHeight: true
				
				TreeNavigationArea {
					width: parent.width; height: parent.height
					y: flickable.contentY
					z: moving ? 1000 : 0

					onMoved: flickable.contentY = Math.max(0, flickable.contentY - delta)
					onMovingFinished: flickable.flick(0.0, 10.0)
					onZoomed: {
						if (toCursor)
							rootSequenceTree.zoomToCursor(delta)
						else
							rootSequenceTree.zoomTo(delta, -mouseX)
					}
				}
				
				TreeView {
					id: treeView
					width: parent.width
					sourceModelAdapter: modelAdapter
					selectionModel: rootSequenceTree.selectionModel
				}
			}

			/******************************************************************
			 * timeline
			 */
			Item {
				id: timeline

				Layout.fillWidth: true
				Layout.fillHeight: true

				Item {
					id: timelineBackground
					width: parent.width; height: flickable.height
					y: flickable.contentY

					TimelineStrokes {
						visible: context && context.sequenceOpened && context.modelSelected
						model: context ? context.timelineController.scaleModel : null

						anchors.fill: parent
					}

					TimelineNavigationArea {
						id: timelineNavArea
						parent: moving ? timelineForeground : timelineBackground
						z: 1000

						anchors.fill: parent

						onMoved: {
							context.timelineController.move(deltaX)
							flickable.contentY = Math.max(0, flickable.contentY - deltaY)
						}

						onMovingFinished: {
							flickable.flick(0.0, 10.0)
						}

						onZoomed: {
							if (toCursor)
								rootSequenceTree.zoomToCursor(delta)
							else
								rootSequenceTree.zoomTo(delta, mouseX)
						}

						onUpdateSelection: {
							if (clearAndSelect && rootSequenceTree.selectionModel) {
								rootSequenceTree.selectionModel.clearSelection()
							}

							if (context.curveMode) {
								curvesView.select(selectionFrame, selectionHelper)
							} else {
								tracksView.select(selectionFrame, selectionHelper)
							}

							selectionHelper.flush(ItemSelectionModel.Select)
						}

						Sequences.SelectionHelper {
							id: selectionHelper
							model: rootSequenceTree.selectionModel
						}
					}
				}

				TimelineTracksView {
					id: tracksView
					sourceModelAdapter: visible ? modelAdapter : null
					selectionModel: visible ? rootSequenceTree.selectionModel : null
					visible: !context.curveMode

					anchors.fill: parent
				}

				Item {
					id: timelineForeground
					width: parent.width; height: flickable.height
					y: flickable.contentY
					clip: true

					CurveViewLoader {
						id: curvesView
						width: parent.width
						sourceModelAdapter: visible ? modelAdapter : null
						selectionModel: visible ? rootSequenceTree.selectionModel : null
						foreground: parent
						visible: context.curveMode && context.sequenceOpened

						anchors.fill: parent
					}

					TimelineGlobalCommentsLines {
						anchors.fill: parent
					}

					SelectionFrame {
						id: selectionFrame
						frameData: timelineNavArea.frameData
					}

					TimelineCursor {
						id: timelineCursor
						height: parent.height
					}
				}
			}
		}
	}

	Item {
		width: timeline.width
		height: timeline.height
		x: timeline.x
		y: timeline.y
		clip: true

		EmptySequencePanel {
			anchors.centerIn: parent
		}
	}

}
