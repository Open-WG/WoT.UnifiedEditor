import QtQuick 2.11
import WGTools.Controls 2.0

Item {
	id: marker

	readonly property real animDuration: 500

	Rectangle {
		id: rect
		width: 1
		height: 2
		color: "white"

		anchors.bottom: parent.bottom
		anchors.bottomMargin: 1
		anchors.alignWhenCentered: false
	}

	Item {
		id: labelDrawer
		width: durationLabel.visible ? durationLabel.width : 0
		height: labelsRow.height
		clip: true

		anchors.bottom: rect.bottom
		anchors.left: rect.right

		Row {
			id: labelsRow

			anchors.right: parent.right

			Label {
				id: textLabel
				text: Math.round(commentData.time * 1.0e2) / 1.0e2 + "s"
				opacity: 0
				leftPadding: 3

				font.bold: true
				font.pixelSize: 10
			}

			Label {
				id: durationLabel
				text: "(duration: " + Math.round(commentData.duration * 1.0e2) / 1.0e2 + "s)"
				opacity: 0
				leftPadding: 3
				y: height * 0.1
				color: Qt.darker(textLabel.color, 1.17)
				visible: commentData.duration > 0

				font.bold: true
				font.pixelSize: 10
			}
		}
	}

	states: State {
		when: commentsCommonData.hoveredGlobalCommentIndex == index

		PropertyChanges { target: rect; height: 12 }
		PropertyChanges { target: textLabel; opacity: 1 }
		PropertyChanges { target: labelDrawer; width: labelsRow.width }
		PropertyChanges {
			target: durationLabel
			opacity: 1
			y: 0
		}
	}

	transitions: [
		Transition {
			from: ""
			ParallelAnimation {
				NumberAnimation { target: rect; property: "height"; duration: marker.animDuration; easing.type: Easing.OutCubic }
				NumberAnimation { target: textLabel; property: "opacity"; duration: marker.animDuration; easing.type: Easing.OutCubic }
				NumberAnimation { target: labelDrawer; property: "width"; duration: marker.animDuration; easing.type: Easing.OutCubic }

				SequentialAnimation {
					PauseAnimation { duration: marker.animDuration }
					NumberAnimation { targets: durationLabel; properties: "opacity,y"; duration: marker.animDuration; easing.type: Easing.OutCubic }
				}
			}
		},
		Transition {
			to: ""

			SequentialAnimation {
				PauseAnimation { duration: 300 }
				ParallelAnimation {
					NumberAnimation { target: rect; property: "height"; duration: marker.animDuration; easing.type: Easing.OutCubic }
					NumberAnimation { target: textLabel; property: "opacity"; duration: marker.animDuration; easing.type: Easing.OutCubic }
					NumberAnimation { target: labelDrawer; property: "width"; duration: marker.animDuration; easing.type: Easing.OutCubic }
					NumberAnimation { targets: durationLabel; properties: "opacity,y"; duration: marker.animDuration / 2; easing.type: Easing.OutCubic }
				}
			}
		}
	]
}
