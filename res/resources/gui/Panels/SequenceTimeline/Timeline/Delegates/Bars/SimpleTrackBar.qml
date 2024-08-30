import QtQuick 2.11
import Panels.SequenceTimeline 1.0

Rectangle {
	readonly property color baseColor: context.colors.color(itemData.colorIndex)

	implicitHeight: Constants.barHeight
	opacity: Constants.trackBarOpacity
	color: context.colors.color(itemData.colorIndex)
}
