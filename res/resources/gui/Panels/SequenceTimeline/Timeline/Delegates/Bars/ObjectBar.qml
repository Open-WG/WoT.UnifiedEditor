import QtQuick 2.11
import WGTools.Misc 1.0 as Misc
import Panels.SequenceTimeline 1.0

Rectangle {
	id: bar
	implicitHeight: Constants.barHeight
	radius: Constants.barRadius
	color: Qt.darker(border.color, 1.5)
	clip: true

	border.width: 1
	border.color: context.colors.color(itemData.colorIndex)

	Misc.Text {
		text: itemData.label
		color: Qt.lighter(bar.border.color, 1.7)
		z: 100

		font.bold: true

		anchors.left: parent.left
		anchors.leftMargin: 5
		anchors.verticalCenter: parent.verticalCenter
	}
}
