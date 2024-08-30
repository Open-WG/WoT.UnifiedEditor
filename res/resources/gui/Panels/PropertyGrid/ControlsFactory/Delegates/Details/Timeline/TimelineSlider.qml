import QtQuick 2.7

import "../../Settings.js" as Settings

Item {
	id: slider

	signal valueModified(real newValue, bool commit)

	property var minDrag: 0
	property var maxDrag: parent.width
	property var value: 0
	property var scale: null

	Binding on x {
		value: timeline.scale.fromValueToPixels(
				slider.value)
	}

	width: 1
	height: width

	anchors.alignWhenCentered: false

	onXChanged: {
		var val = Math.round(scale.fromPixelsToValue(x))
		x = scale.fromValueToPixels(val)
		slider.valueModified(val, false)
	}

	Connections {
		target: timeline.scale
		onScaleChanged: x = timeline.scale.fromValueToPixels(
				value)
	}

	Rectangle {
		id: sliderFrame

		antialiasing: true

		height: sliderMA.drag.active 
			? Settings.timelineSliderHeightDrag
			: Settings.timelineSliderHeight
		width: sliderMA.drag.active 
			? Settings.timelineSliderWidthDrag
			: Settings.timelineSliderWidth

		anchors.centerIn: parent
		anchors.alignWhenCentered: false

		color: enabled 
			? activeFocus
				? Settings.timelineSliderFocusedBackgroundColor
				: Settings.timelineSliderDefaultBackgroundColor
			: Settings.timelineSliderDisabledColor

		radius: Settings.timelineSliderRadius

		Rectangle {
			width: 1
			height: 11

			color: sliderFrame.activeFocus
				? Settings.timelineSliderFocusedStrokeColor
				: Settings.timelineSliderDefaultStrokeColor

			anchors.centerIn: sliderFrame
			anchors.alignWhenCentered: false
		}

		MouseArea {
			id: sliderMA

			property var _waitingDrag: false

			anchors.fill: sliderFrame

			drag.target: slider
			drag.axis: Drag.XAxis
			drag.minimumX: slider.minDrag
			drag.maximumX: slider.maxDrag

			onPressed: sliderFrame.forceActiveFocus(Qt.MouseFocusReason)

			drag.onActiveChanged: {
				if (drag.active) {
					sliderMA._waitingDrag = true
				}
				else if (sliderMA._waitingDrag) {
					sliderMA._waitingDrag = false
					value = slider.scale.fromPixelsToValue(slider.x)
					slider.valueModified(
						value, true)
				}
			}
		}
	}
}
