import QtQuick 2.11

ToolButton {
	id: control
	hoverEnabled: true
	focusPolicy: Qt.NoFocus

	Accessible.name: text

	Binding {
		target: backgroundRect
		property: "color"
		value: "#ff5b5b"
		when: control.checked
	}

	AnimatedImage {
		id: animation
		source: "rec_animation.gif"
		visible: control.checked
		playing: control.checked
		parent: control.buttonItem
		anchors.centerIn: parent

		onVisibleChanged: if (visible) {
			currentFrame = 0
		}
	}
}
