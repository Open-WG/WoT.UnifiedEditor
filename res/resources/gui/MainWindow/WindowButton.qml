import QtQuick 2.7
import "Settings.js" as Settings

MouseArea {
	id: button

	property alias source: image.source

	implicitWidth: Settings.windowButtonWidth
	implicitHeight: Settings.titlebarHeight
	hoverEnabled: true

	Rectangle {
		color: button.containsPress
			? _palette.color12
			: button.containsMouse || button.pressed
				? _palette.color6
				: "transparent"
			
		anchors.fill: parent
	}

	Image {
		id: image
		anchors.centerIn: parent
	}
}
