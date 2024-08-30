import QtQuick 2.7
import "Settings.js" as Settings

MouseArea {
	id: button
	implicitWidth: image.implicitWidth
	implicitHeight: image.implicitHeight
	hoverEnabled: true

	Rectangle {
		color: _palette.color12
		opacity: button.containsPress
			? 1
			: button.containsMouse || button.pressed
				? 0.2
				: 0
			
		anchors.fill: parent

		Behavior on opacity {
			NumberAnimation { duration: Settings.tabButtonHighlightingDuration; easing.type: Easing.OutQuad }
		}
	}

	Image {
		id: image
		source: "image://gui/icon-sys-close?color=" + encodeURIComponent(_palette.color2)
		anchors.centerIn: parent
	}
}