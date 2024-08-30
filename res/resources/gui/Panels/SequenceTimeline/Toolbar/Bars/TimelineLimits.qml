import QtQml 2.7
import QtQuick 2.7
import QtQuick.Layouts 1.3
import Panels.SequenceTimeline.Edits 1.0
import ".."

RowLayout {
	spacing: 5

	function getFramesFromEdit(edit) {
		// string already validated
		if (edit.text.length == 0){
			return 0.0
		}

		var framesText = edit.text
		var lastChar = framesText[framesText.length - 1]
		var editNumber = 0.0

		if (framesText.length == 1 && (lastChar == 's' || lastChar == 'm')){
			return 0.0
		}

		if (('0' <= lastChar && lastChar <= '9')) {
			edit.text = framesText + 's'
			editNumber = parseFloat(framesText) * context.frameRate
		} else {
			editNumber = parseFloat(framesText.substring(0, framesText.length - 1))
			if (lastChar == 's') {
				editNumber *= context.frameRate
			} else if (lastChar == 'm') {
				editNumber *= 60 * context.frameRate
			}
		}

		// just some big number to limit upper bound
		// will assume that there is no sequences longer
		// than 5 hours
		if (editNumber > 1000000.0){
			editNumber = 1000000.0
		}

		return editNumber
	}

	LimitsEdit {
		id: leftEdit
		caption: "Start"
		text: getLeftBorderText()
		enabled: context.sequenceOpened
		onEditingFinished: {
			context.timelineLimitController.leftBorder = getFramesFromEdit(leftEdit)
			text = getLeftBorderText()
		}

		function getLeftBorderText() {
			return Math.round(context.timelineLimitController.leftBorder / context.frameRate * 1.0e4) / 1.0e4 + "s"
		}

		Binding on text {
			value: leftEdit.getLeftBorderText()
		}
	}

	LimitsEdit {
		id: rightEdit
		caption: "End"
		enabled: context.sequenceOpened
		onEditingFinished: {
			context.timelineLimitController.rightBorder = getFramesFromEdit(rightEdit)
			text = getRightBorderText()
		}

		function getRightBorderText() {
			return Math.round(context.timelineLimitController.rightBorder / context.frameRate * 1.0e4) / 1.0e4 + "s"
		}

		Binding on text {
			value: rightEdit.getRightBorderText()
		}
	}

	ToolbarCaptionWrapper {
		text: ""
		Text {
			id: duration
			text: "= "
				+ Math.round(context.timelineLimitController.rightBorder - context.timelineLimitController.leftBorder)
				+ "f"
			color: _palette.color1
		}
	}
}
