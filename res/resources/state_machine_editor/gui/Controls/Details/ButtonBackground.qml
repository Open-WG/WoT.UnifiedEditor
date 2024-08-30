import QtQuick 2.7
import "Settings.js" as ControlsSettings

Rectangle {
	width: parent.width
	height: parent.height
	
	implicitWidth: ControlsSettings.buttonHeight
	implicitHeight: ControlsSettings.buttonHeight
	radius: ControlsSettings.radius
	color: !control.enabled
		? "transparent"
		: control.down || control.checked
			? "#888888"
			: control.activeFocus
				? "#0093FF"
				: "#666666"
	visible: !control.flat || control.down || control.checked || control.highlighted

	border.width: ControlsSettings.thickBorderWidth
	border.color: control.enabled
		? "transparent"
		: "#666666"
}
