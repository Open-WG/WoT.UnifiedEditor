import QtQuick 2.7
import WGTools.Shapes 1.0 as Shapes
import "Settings.js" as ControlsSettings

Item {
	property alias color: img.color

	implicitWidth: img.implicitWidth
	implicitHeight: img.implicitHeight
	height: control.availableHeight
	x: control.width - control.padding - width
	y: control.topPadding

	Shapes.Triangle {
		id: img
		implicitWidth: ControlsSettings.comboBoxIndicatorWidth
		implicitHeight: ControlsSettings.comboBoxIndicatorHeight
		color: control.enabled ? "#000000" : "#333333"
		anchors.centerIn: parent
		anchors.verticalCenterOffset: control.pressed ? ControlsSettings.buttonPressedOffset : 0
	}

	transform: Rotation { 
		origin.x: width / 2
		origin.y: height / 2
		angle: (control.popup != undefined && control.popup.visible) ? 180 : 0
	}
}
