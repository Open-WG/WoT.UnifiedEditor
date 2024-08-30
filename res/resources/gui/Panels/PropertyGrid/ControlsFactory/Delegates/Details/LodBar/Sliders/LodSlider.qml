import QtQuick 2.7

Item {
	id: control

	property real fullRange: 0
	property real from: 0
	property real to: 99
	property real value: 0

	readonly property bool pressed: controller.containsPress || controller.pressed 
	readonly property bool hovered: handle.containsMouse

	signal modified(bool commit, int modifiers)

	LodSliderLimitsMarker {
	}

	LodSliderController {
		id: controller
		handlePosX: handle.x + handle.width / 2
		onModified: control.modified(commit, modifiers)
	}

	LodSliderHandle {
		id: handle
	}
}
