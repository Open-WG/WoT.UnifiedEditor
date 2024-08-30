import QtQuick 2.11
import Panels.SequenceTimeline 1.0

Rectangle {
	id: frame

	property SelectionFrameData frameData: null

	color: Qt.rgba(border.color.r, border.color.g, border.color.b, 0.2)

	border.width: 2
	border.color: Constants.selectionColor

	Binding on x { value: frame.frameData.minX; when: frame.frameData != null }
	Binding on y { value: frame.frameData.minY; when: frame.frameData != null }
	Binding on width { value: frame.frameData.width; when: frame.frameData != null }
	Binding on height { value: frame.frameData.height; when: frame.frameData != null }
	Binding on visible { value: frame.frameData.active; when: frame.frameData != null }
}
