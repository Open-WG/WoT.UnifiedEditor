import QtQuick 2.7

Item {
	readonly property real _indicatorsOffset: (1-opacity) * 3
	readonly property real _fromPos: control.fullRange ? control.from / control.fullRange : 0
	readonly property real _toPos: control.fullRange ? control.to / control.fullRange : 0

	width: parent.width
	height: parent.height
	opacity: control.pressed ? 1 : 0

	Behavior on opacity {
		NumberAnimation { duration: 200; easing.type: Easing.OutQuart }
	}

	LimitIndicator {
		height: parent.height
		x: (parent.width * parent._fromPos) - width - parent._indicatorsOffset
	}

	LimitIndicator {
		height: parent.height
		x: (parent.width * parent._toPos) + parent._indicatorsOffset
	}
}
