import QtQuick 2.11
import Panels.SequenceTimeline 1.0
import "Bars"

Item {
	height: Constants.rowHeight
	clip: true

	Loader {
		id: bar

		property real _startX
		property real _endX

		source: itemData.isSound() ? "Bars/SoundBar.qml" : "Bars/ObjectBar.qml"
		width: _endX - _startX
		x: _startX
		y: (parent.height - height) / 2 // vertcal center

		function calcStartX() {
			return Math.round(context.timelineController.fromSecondsToScale(itemData.startPosition))
		}

		function calcEndX() {
			return Math.round(context.timelineController.fromSecondsToScale(itemData.endPosition))
		}

		Binding on _startX { value: bar.calcStartX() }
		Binding on _endX { value: bar.calcEndX() }

		Connections {
			target: context.timelineController
			ignoreUnknownSignals: false
			onScaleChanged: {
				bar._startX = bar.calcStartX()
				bar._endX = bar.calcEndX()
			}
		}
	}
}
