import QtQuick 2.7
import QtQml.Models 2.2

import CurvePainter 1.0
import CurvePainterModes 1.0
import TimelineCurveBuilder 1.0
import "Constants.js" as Constants
import "Debug"

Item {
	id: editorView

	clip: true

	function selectKeys(selModel, box, selection) {
		curveEditorViewKeys.selectKeys(selModel, box, selection)
	}

	CurveEditorViewScale {
		id: curveEditorViewScale

		height: editorView.height
		timelineController: styleData.context.timelineController
		context: styleData.context

		Component.onCompleted: {
			if (styleData.curveContainer) {
				if (model.itemCurveContainer.scaleStart > model.itemCurveContainer.scaleEnd)
					controller.focusAroundCurves(model.itemCurveContainer)
				else
					controller.focusAroundRange(model.itemCurveContainer.scaleStart,
						model.itemCurveContainer.scaleEnd)
			}
		}

		Connections {
			target: curveEditorViewScale.controller

			onScaleChanged: {
				model.itemCurveContainer.scaleStart = curveEditorViewScale.controller.start
				model.itemCurveContainer.scaleEnd = curveEditorViewScale.controller.end
			}
		}
	}

	Repeater {
		id: curveRepeater

		model: styleData.curveContainer

		delegate: CurvePainter {
			anchors.fill: parent

			antialiasingEnabled: true

			color: styleData.trackProxy ? styleData.trackProxy.elements[index].color : "white"
			visible: styleData.trackProxy ? styleData.trackProxy.elements[index].visible : false

			modes: CurvePainterModes.InvertedOnY

			curveBuilder: TimelineCurveBuilder {
				curve: modelData
				pixelsPerLine: 4

				timelineController: styleData.context.timelineController
				curveEditorController: curveEditorViewScale.controller
			}
		}
	}

	CurveEditorViewKeys {
		id: curveEditorViewKeys

		clip: true

		model: styleData.sourceModel
		rootIndex: styleData.modelIndex
		context: styleData.context
		curveEditorController: curveEditorViewScale.controller
		trackProxy: styleData.trackProxy
		selectionModel: styleData.selectionModel
		timelineViewID: styleData.timelineViewID
		curveViewID: editorView
		keyDeleteSignalHolder: styleData.keyDeleteSignalHolder
		
		anchors.fill: parent
	}
	
	Binding {
		target: curveEditorViewScale.controller
		property: "controlSize"
		value: Math.max(editorView.height, 0)
	}
}
