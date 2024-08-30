import QtQuick 2.11
import QtGraphicalEffects 1.0
import Panels.SequenceTimeline 1.0

Item {
	id: key
	implicitWidth: Constants.keySize
	height: width
	rotation: 45

	DropShadow {
		horizontalOffset: 2
		verticalOffset: 2
		radius: 8.0
		samples: 17
		color: "#80000000"
		source: rect

		anchors.fill: key
	}

	Rectangle {
		id: rect
		width: parent.width
		height: parent.height
		radius: 2
		color: context.colors.color(itemData.colorIndex)

		border.width: 2
		border.color: color
	}

	state: ""
	states: State {
		name: "selected"

		PropertyChanges {
			target: key
			width: Constants.keySelectedSize
		}

		PropertyChanges {
			target: rect
			border.color: Qt.lighter(rect.color, 1.7)
		}
	}

	transitions: Transition {
		ParallelAnimation {
			NumberAnimation { target: key; properties: "width"; easing.type: Easing.OutCubic; duration: 100 }
			ColorAnimation { target: rect.border; property: "color"; easing.type: Easing.OutCubic; duration: 100 }
		}
	}
}
