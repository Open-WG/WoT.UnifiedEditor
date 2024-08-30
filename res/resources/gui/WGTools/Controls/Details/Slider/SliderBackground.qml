import QtQuick 2.11
import WGTools.Controls.Details 2.0

Item {
	implicitWidth: control.horizontal ? ControlsSettings.width : ControlsSettings.height
	implicitHeight: control.horizontal ? ControlsSettings.height : ControlsSettings.width
	z: -2
}
