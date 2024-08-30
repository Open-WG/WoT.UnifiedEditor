import QtQuick 2.7
import QtGraphicalEffects 1.0

import "Settings.js" as ControlsSettings

Item {
	property alias color: rect.color
	property alias border: rect.border

	Rectangle {
		id: rect
		color: "#d4d4d4"
		radius: ControlsSettings.radius
		anchors.fill: parent
	}

	// TODO: use overlay for shadows

	DropShadow {
		cached: true
		source: rect
		radius: 16
		samples: radius * 2
		transparentBorder: true
		verticalOffset: 4
		opacity: 0.5
		color: "#ffffff"
		
		anchors.fill: rect
	}

	DropShadow {
		cached: true
		source: rect
		radius: 4
		samples: radius * 2
		transparentBorder: true
		verticalOffset: 2
		opacity: 0.7
		color: "#ffffff"
		
		anchors.fill: rect
	}
}
