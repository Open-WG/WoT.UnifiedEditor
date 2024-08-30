import QtQuick 2.11
import Panels.SequenceTimeline 1.0

Item {
	property alias model: repeater.model

	Accessible.name: "Timeline View"

	clip: true

	Repeater {
		id: repeater

		delegate: Rectangle {
			width: Constants.strokeWidth
			height: parent.height
			opacity: model.majorityCoeff
			color: "black"
			x: Math.round(model.position)
		}
	}
}
