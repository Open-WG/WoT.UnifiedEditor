import QtQuick 2.11
import WGTools.Controls.Details 2.0

Rectangle {
	id: separator
	y: control.topPadding + (control.availableHeight - height) / 2
	implicitWidth: ControlsSettings.strokeWidth
	implicitHeight: control.availableHeight
	color: _palette.color5
}
