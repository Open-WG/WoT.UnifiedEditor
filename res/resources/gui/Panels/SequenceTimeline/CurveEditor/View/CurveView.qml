import QtQuick 2.11
import QtQml.Models 2.2
import QtQml.StateMachine 1.0 as SM
import WGTools.AnimSequences 1.0
import Panels.SequenceTimeline 1.0

Item {
	id: view

	readonly property bool dataEnabled: styleData.data != null && styleData.data.curveContainer != null

	clip: true

	function selectKeys(box, selection) {
		keys.selectKeys(box, selection)
	}

	function fitScale() {
		curveController.focusAroundCurves(styleData.data.curveContainer);
		styleData.data.curveContainer.scaleStart = curveController.start
		styleData.data.curveContainer.scaleEnd = curveController.end
		styleData.data.curveContainer.scaleFixed = true
	}

	SM.StateMachine {
		id: logic
		initialState: styleData.data == null ? emptyState : curveState
		running: true

		SM.State {
			id: emptyState

			SM.SignalTransition {
				targetState: curveState
				signal: styleData.dataChanged
				guard: view.dataEnabled
			}
		}

		SM.State {
			id: curveState
			initialState: initingState

			SM.State {
				id: initingState

				function updateScale() {
					if (styleData.data.curveContainer.scaleFixed) {
						var start = styleData.data.curveContainer.scaleStart
						var end = styleData.data.curveContainer.scaleEnd
						curveController.focusAroundRange(start, end)
					} else {
						curveController.focusAroundCurves(styleData.data.curveContainer);
					}
				}

				onEntered: {
					updateScale()
				}

				SM.TimeoutTransition {
					targetState: initedState
					timeout: 0
				}
			}

			SM.State {
				id: initedState

				onEntered: {
					keys.rootIndex = styleData.modelIndex
					keys.model = styleData.modelAdapter
				}

				onExited: {
					keys.model = null
					keys.rootIndex = null
				}

				SM.SignalTransition {
					targetState: initingState
					signal: styleData.dataChanged
					guard: view.dataEnabled
				}

				SM.SignalTransition {
					targetState: emptyState
					signal: styleData.dataChanged
					guard: !view.dataEnabled
				}

				Connections {
					enabled: initedState.active
					target: curveController
					onScaleChanged: {
						styleData.data.curveContainer.scaleStart = curveController.start
						styleData.data.curveContainer.scaleEnd = curveController.end
						styleData.data.curveContainer.scaleFixed = true
					}
				}
			}
		}
	}

	CurveEditorController {
		id: curveController
		controlSize: Math.max(view.height, 0)
	}

	CurveScale {
		width: parent.width
		height: parent.height
		model: curveController.scaleModel
	}

	CurveNavigator {
		width: parent.width
		height: parent.height
		
		onZoomedVertically: curveController.zoom(delta, position)
		onZoomedHorizontally: context.timelineController.zoom(delta, position)
		onMoved: {
			curveController.move(-deltaY)
			context.timelineController.move(deltaX)
		}

		onDoubleClicked: {
			if (view.dataEnabled && containsMouse && mouse.button == Qt.LeftButton) {
				var frame = context.timelineController.fromScreenToScaleClipped(mouseX)
				var seconds = context.timelineController.fromFramesToSeconds(frame)

				styleData.data.insertKeyAt(seconds)
			}
		}
	}

	Repeater {
		model: view.dataEnabled ? styleData.data.curveContainer.curves : null

		delegate: CurvePainter {
			width: parent.width
			height: parent.height
			antialiasingEnabled: true
			modes: CurvePainter.InvertedOnY
			color: {
				var c = "white"

				if (index == -1)
					return c

				if (keys.trackProxy == null)
					return c
				
				var element = keys.trackProxy.elements[index]
				if (element == null)
					return c

				return element.color
			}
			visible: {
				if (index == -1)
					return false

				if (keys.trackProxy == null)
					return false

				var element = keys.trackProxy.elements[index]
				if (element == null)
					return false

				if (element.disabled)
					return false

				return element.visible
			}

			curveBuilder: TimelineCurveBuilder {
				curve: modelData
				pixelsPerLine: 4
				timelineController: context.timelineController
				curveEditorController: curveController
			}
		}
	}

	CurveKeysContainer {
		id: keys
		width: parent.width
		height: parent.height
		curveEditorController: curveController
		trackProxy: view.dataEnabled ? styleData.data.decomposedValues : null
		selectionModel: styleData.selectionModel
		timelineViewID: styleData.timelineViewID
		curveViewID: view
	}
}
