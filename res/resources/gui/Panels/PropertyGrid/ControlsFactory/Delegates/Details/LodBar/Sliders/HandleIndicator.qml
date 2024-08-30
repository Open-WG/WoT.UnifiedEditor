import QtQuick 2.7
import "../../../Settings.js" as Settings

Item {
	id: root

	property bool active: false
	
	states: State {
		when: root.active

		PropertyChanges {
			target: indicator
			opacity: 1
			scale: 1
		}
	}

	transitions: Transition {
		SequentialAnimation {
			PauseAnimation { duration: Settings.interactionAnimDelay }
			ParallelAnimation {
				NumberAnimation { property: "opacity"; duration: Settings.interactionAnimDuration; easing.type: Easing.OutCubic }
				NumberAnimation { property: "scale"; duration: Settings.interactionAnimDuration; easing.type: Easing.OutBack }
			}
		}
	}

	Rectangle {
		id: indicator
		radius: 6
		width: radius * 2
		height: radius * 2
		color: "white"; // TODO: get color from palette
		opacity: 0
		scale: 0.5

		anchors.centerIn: parent

		Canvas {
			property color color: "black" // TODO: get color from palette

			antialiasing: true
			onColorChanged: requestPaint()
			onWidthChanged: requestPaint()
			onHeightChanged: requestPaint()
			onPaint: {
				var ctx = getContext("2d")
				var hPadding = 2
				var vPadding = 3

				ctx.reset()
				ctx.moveTo((width - hPadding) / 2, vPadding)
				ctx.lineTo((width - hPadding) / 2, height - vPadding)
				ctx.lineTo(hPadding, height / 2)
				ctx.closePath()

				ctx.moveTo((width + hPadding) / 2, vPadding)
				ctx.lineTo((width + hPadding) / 2, height - vPadding)
				ctx.lineTo(width - hPadding, height / 2)
				ctx.closePath()

				ctx.fillStyle = color
				ctx.fillRule = Qt.WindingFill
				ctx.fill()
			}

			anchors.fill: parent
		}
	}
}
