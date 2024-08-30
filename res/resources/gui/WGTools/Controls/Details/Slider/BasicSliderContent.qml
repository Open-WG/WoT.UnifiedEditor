import QtQuick 2.11
import WGTools.Controls.Details 2.0

Item {
	id: item
	z: -1

	property alias groove: groove
	property alias leftLabel: leftLabel
	property alias rightLabel: rightLabel

	property real __leftPadding: 0
	property real __rightPadding: __leftPadding
	property real __topPadding: 0
	property real __bottomPadding: __topPadding

	SliderGroove {
		id: groove
		width: control.horizontal ? control.availableWidth - (item.__leftPadding + __rightPadding) : implicitWidth
		height: control.vertical ? control.availableHeight - (item.__topPadding + item.__bottomPadding) : implicitHeight
		x: control.horizontal ? item.__leftPadding : (control.availableWidth - width) / 2
		y: control.vertical ? item.__topPadding : (control.availableHeight - height) / 2
	}

	SliderScale {
		anchors.fill: groove
	}

	SliderLabel {
		id: leftLabel
		value: control.mirrored ? control.to : control.from
		visible: control.labels.visible
		anchors {
			top: groove.verticalCenter
			bottom: parent.bottom
			horizontalCenter: groove.left
			horizontalCenterOffset: Math.max(0, width / 2 - item.__leftPadding)
		}
	}

	SliderLabel {
		id: rightLabel
		value: control.mirrored ? control.from : control.to
		visible: control.labels.visible
		anchors {
			top: groove.verticalCenter
			bottom: parent.bottom
			horizontalCenter: groove.right
			horizontalCenterOffset: Math.min(0, item.__rightPadding - width / 2)
		}
	}
}
