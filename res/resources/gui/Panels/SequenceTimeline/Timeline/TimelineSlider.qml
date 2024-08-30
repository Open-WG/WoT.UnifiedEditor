import QtQuick 2.11
import WGTools.Controls.Controllers 1.0

TimelineSliderUI {
	id: slider
	enabled: context.sequenceOpened
	visible: context.sequenceOpened

	function getVisibleFramesRange() {
		return context.timelineController.end - context.timelineController.start
	}

	function getVisibleFramesPerPixel() {
		return getVisibleFramesRange() / context.timelineController.controlSize
	}

	function getFrom() {
		return context.timelineLimitController.leftBorder
	}

	function getTo() {
		return context.timelineLimitController.rightBorder
	}

	function getFirstValue() {
		return context.timelineController.start
	}

	function getSecondValue() {
		return context.timelineController.end
	}

	function getStart(position) {
		return context.timelineLimitController.leftBorder + position * (context.timelineLimitController.rightBorder - context.timelineLimitController.leftBorder)
	}

	function getEnd(position) {
		return context.timelineLimitController.leftBorder + position * (context.timelineLimitController.rightBorder - context.timelineLimitController.leftBorder)
	}

	Binding on from {
		value: slider.getFrom()
	}

	Binding on to {
		value: slider.getTo()
	}

	Binding on first.value {
		value: slider.getFirstValue()
		when: !slider.first.pressed && !slider.second.pressed
	}
	
	Binding on second.value {
		value: slider.getSecondValue()
		when: !slider.first.pressed && !slider.second.pressed
	}

	Connections {
		enabled: !slider.first.pressed && !slider.second.pressed && !slider.moving
		target: context.timelineController
		ignoreUnknownSignals: false
		onScaleChanged: {
			slider.from = slider.getFrom()
			slider.to = slider.getTo()
			slider.first.value = slider.getFirstValue()
			slider.second.value = slider.getSecondValue()
		}
	}

	onMoved: {
		var start = slider.getStart(newFirstPosition)
		var end = slider.getEnd(newSecondPosition)

		context.timelineController.focusAroundRange(start, end)
	}

	RangeSliderController {
		onFirstModified: {
			context.timelineController.focusAroundRange(slider.getStart(slider.first.position), context.timelineController.end)
		}

		onSecondModified: {
			context.timelineController.focusAroundRange(context.timelineController.start, slider.getEnd(slider.second.position))
		}
	}
}
