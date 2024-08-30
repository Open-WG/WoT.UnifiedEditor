import QtQuick 2.7
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Resources 1.0 as WGTResources

Rectangle {
	id: hoverIndicator

	property bool dragExists: false
	property bool containsDrag: false

	visible: dragExists || containsDrag
	radius: ControlsSettings.radius
	border.width: 2
	border.color: _palette.color12
	color: Qt.rgba(_palette.color12.r, _palette.color12.g, _palette.color12.b, 0.3)
}
