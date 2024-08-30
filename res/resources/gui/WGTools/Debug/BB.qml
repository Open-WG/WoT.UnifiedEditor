import QtQuick 2.7

Rectangle {
	id: bb
	property color c: "red"
	property bool sp: false // showPaddings
	property var a: parent

	color: "transparent"
	enabled: false
	
	anchors {
		fill: a
		topMargin: sp ? a.topPadding : undefined
		bottomMargin: sp ? a.bottomPadding : undefined
		leftMargin: sp ? a.leftPadding : undefined
		rightMargin: sp ? a.rightPadding : undefined
	}

	border {
		width: 1
		color: c
	}
}
