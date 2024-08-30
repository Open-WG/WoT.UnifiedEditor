import QtQuick 2.11

Item {
	id: item

	property alias expaned: expandedData

	states: State {
		name: "expanded"

		PropertyChanges {
			target: rect
			radius: item.expaned.radius
			opacity: item.expaned.opacity
			color: item.expaned.color
			coef: 0
		}
	}

	transitions: Transition {
		ParallelAnimation {
			NumberAnimation { target: rect; properties: "radius, opacity, coef"; duration: 500; easing.type: Easing.OutCubic }
			ColorAnimation { target: rect; duration: 500; easing.type: Easing.OutCubic }
		}
	}

	ExpandedData {
		id: expandedData
		radius: rect.radius
		opacity: rect.opacity
		color: rect.color
	}
	
	Rectangle {
		id: rect

		property real coef: 1

		width: parent.width - (control.leftPadding + control.rightPadding) * coef
		height: parent.height - (control.topPadding + control.bottomPadding) * coef
		x: (parent.width - width) / 2
		y: (parent.height - height) / 2
		radius: height / 2
		color: "red"
	}
}
