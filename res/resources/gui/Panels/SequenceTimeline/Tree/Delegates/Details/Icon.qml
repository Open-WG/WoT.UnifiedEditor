import QtQuick 2.11
import Panels.SequenceTimeline 1.0

Rectangle {
	property alias source: image.source

	implicitWidth: Constants.seqTreeIconFrameWidth
	implicitHeight: Constants.seqTreeIconFrameHeight

	Accessible.name: "Icon"
	Image {
		id: image
		sourceSize.width: Constants.seqTreeIconWidth
		sourceSize.height: Constants.seqTreeIconHeight

		anchors.verticalCenter: parent.verticalCenter
	}
}
