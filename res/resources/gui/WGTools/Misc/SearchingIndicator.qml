import QtQuick 2.7

Item {

	id: root
	visible: false
	width: parent.width

	property real duration: 2000
	property real interval: 0
	property var easingType: Easing.InOutCirc
	property alias color: rect.color
	property alias colorIn: colorAnim.to
	property alias colorOut: colorAnim.from

	onVisibleChanged: {
		if (visible)
		{
			anim.restart()
		}
		else
		{
			anim.stop()
		}
	}

	Rectangle {
		id: rect
		
		property real widthProgress: 0
		property real xProgress: 0

		x: parent.width * xProgress
		width: Math.min(parent.width - x, parent.width * widthProgress)
		
		implicitHeight: 2
		
		// gradient: Gradient {
		// 	GradientStop { position: 0.0; color: "transparent" }
		// 	GradientStop { position: 1.0; color: rect.color }
		// }

		anchors.bottom: parent.bottom

		AnimationController {
			progress: rect.width / rect.parent.width

			ColorAnimation {
				id: colorAnim
				target: rect
				property: "color"

				from: _palette.color12
				to: _palette.color12
			}
		}

		SequentialAnimation {
			id: anim
			loops: Animation.Infinite

			PropertyAction { target: rect; property: "widthProgress"; value: 0 }
			PropertyAction { target: rect; property: "xProgress"; value: 0 }

			NumberAnimation {
				target: rect
				property: "widthProgress"
				from: 0
				to: 1
				duration: root.duration * 0.5

				easing.type: root.easingType
			}

			NumberAnimation {
				target: rect
				property: "xProgress"
				from: 0
				to: 1
				duration: root.duration * 0.5

				easing.type: root.easingType
			}

			PauseAnimation { duration: root.interval }
		}
	}
}