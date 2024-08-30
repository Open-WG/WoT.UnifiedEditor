import QtQuick 2.7

Item {
	id: dot
	implicitWidth: 18
	implicitHeight: width
	
	property real duration: 1000
	property real medianCoef: 0.4
	property real nextAnimCoef: 0.2
	property real outWidth: 2
	property real outOpacity: 0.4
	property int inEasingType: Easing.OutQuad
	property int outEasingType: Easing.InQuad

	signal nextAnimation()
	signal animFinished()

	function startAnimation() {
		anim.start()
		timer.restart()
	}

	Timer {
		id: timer
		interval: dot.duration * dot.nextAnimCoef
		onTriggered: dot.nextAnimation()
	}

	Rectangle {
		id: rect
		width: dot.outWidth
		height: width
		radius: width / 2
		color: "white"
		opacity: dot.outOpacity
		x: (parent.width - width) / 2
		y: (parent.height - height) / 2

		SequentialAnimation {
			id: anim
			onStopped: dot.animFinished()

			ParallelAnimation {
				NumberAnimation { target: rect; property: "opacity"; from: dot.outOpacity; to: 1; duration: dot.duration * medianCoef; easing.type: dot.inEasingType }
				NumberAnimation { target: rect; property: "width"; from: dot.outWidth; to: dot.width; duration: dot.duration * medianCoef; easing.type: dot.inEasingType }
			}

			ParallelAnimation {
				NumberAnimation { target: rect; property: "opacity"; from: 1; to: dot.outOpacity; duration: dot.duration * (1 - medianCoef); easing.type: dot.outEasingType }
				NumberAnimation { target: rect; property: "width"; from: dot.width; to: dot.outWidth; duration: dot.duration * (1 - medianCoef); easing.type: dot.outEasingType }
			}
		}
	}
}