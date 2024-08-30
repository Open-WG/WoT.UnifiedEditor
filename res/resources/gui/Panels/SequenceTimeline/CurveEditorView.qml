import QtQuick 2.7
import QtQml.Models 2.2

import WGTools.AnimSequences 1.0

import "Constants.js" as Constants

Item {
	id: editorView

	clip: true

	function selectKeys(selModel, box, selection) {
		curveEditorViewKeys.selectKeys(selModel, box, selection)
	}

	CurveEditorViewScale {
		id: curveEditorViewScale

		property var initFocus: false

		height: editorView.height
		timelineController: styleData.context.timelineController
		context: styleData.context

		Component.onCompleted: {
			if (styleData.curveContainer && curveEditorViewScale.controller.controlSize > 0)
			{
				if (styleData.isScaleInitialized)
				{
					var start = itemData.curveContainer.scaleStart;
					var end = itemData.curveContainer.scaleEnd;
					curveEditorViewScale.controller.focusAroundRange(start, end);
				}
				else
				{
					curveEditorViewScale.controller.focusAroundCurves(itemData.curveContainer);
					styleData.isScaleInitialized = true;
				}
			}
		}

		Connections {
			target: curveEditorViewScale.controller

			onScaleChanged: {
				itemData.curveContainer.scaleStart = curveEditorViewScale.controller.start
				itemData.curveContainer.scaleEnd = curveEditorViewScale.controller.end
			}

			onControlSizeChanged: {
				if (styleData.curveContainer && curveEditorViewScale.controller.controlSize > 0)
				{
					if (!styleData.isScaleInitialized)
					{
						curveEditorViewScale.controller.focusAroundCurves(itemData.curveContainer);
						styleData.isScaleInitialized = true;
					}
				}
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
			visible: styleData.trackProxy
				? (styleData.trackProxy.elements[index].disabled ? false
					: styleData.trackProxy.elements[index].visible)
				: false

			modes: CurvePainter.InvertedOnY

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
