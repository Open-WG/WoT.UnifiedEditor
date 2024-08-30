import QtQuick 2.11
import QtGraphicalEffects 1.0
import WGTools.Controls.Details 2.0
import WGTools.Controls.impl 1.0

Item {
	property alias color: rect.color
	property alias border: rect.border

	readonly property alias shadowRadius: bigShadow.radius

	Rectangle {
		id: rect
		width: parent.width
		height: parent.height
		radius: ControlsSettings.radius
		color: _palette.color8
		border.width: ControlsSettings.strokeWidth
		border.color: _palette.color9
	}

	DropShadow {
		id: bigShadow
		width: parent.width
		height: parent.height
		cached: true
		color: Color.transparent(_palette.color10, ControlsSettings.popupShadow1Opacity)
		radius: ControlsSettings.popupShadow1Radius
		samples: radius * 1.5
		source: rect
		transparentBorder: true
		verticalOffset: ControlsSettings.popupShadow1VOffset
	}

	DropShadow {
		width: parent.width
		height: parent.height
		cached: true
		color: Color.transparent(_palette.color10, ControlsSettings.popupShadow2Opacity)
		radius: ControlsSettings.popupShadow2Radius
		samples: radius * 1.5
		source: rect
		transparentBorder: true
		verticalOffset: ControlsSettings.popupShadow2VOffset
	}
}
