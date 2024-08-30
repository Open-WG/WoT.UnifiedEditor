import QtQuick 2.11
import WGTools.AnimSequences 1.0 as Sequences
import "../Bars"
import "../Bars/Details"

Item {
	id: key

	readonly property alias barColor: bar.color

	implicitHeight: bar.implicitHeight

	SimpleTrackBar {
		id: bar

		property real sizeOffset: 0

		width: parent.width + sizeOffset
		height: parent.height + sizeOffset

		anchors.centerIn: parent
		anchors.alignWhenCentered: false
	}

	TrackAudiowave {
		height: parent.height / 2
		anchors.bottom: parent.bottom
		visible: switch (itemData.specialStyle) {
			case Sequences.SpecialStyleTypes.PlayTillEndStyle:
			case Sequences.SpecialStyleTypes.OneShotStyle:
				return true
			default:
				return false
		}
	}

	Rectangle {
		id: frame
		color: "transparent"
		z: 10
		opacity: 0

		border.width: 2
		border.color: Qt.lighter(bar.color, 1.7)

		anchors.fill: bar
	}

	state: ""
	states: State {
		name: "selected"

		PropertyChanges {
			target: bar
			sizeOffset: 4
		}

		PropertyChanges {
			target: frame
			opacity: 1
		}
	}

	transitions: Transition {
		ParallelAnimation {
			NumberAnimation { target: bar; properties: "sizeOffset"; easing.type: Easing.OutCubic; duration: 100 }
			NumberAnimation { target: frame; property: "opacity"; easing.type: Easing.OutCubic; duration: 100 }
		}
	}
}
