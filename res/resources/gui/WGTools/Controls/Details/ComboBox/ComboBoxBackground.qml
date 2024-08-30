import QtQuick 2.11
import WGTools.Controls.Details 2.0

Loader {
	id: loader
	width: control.width
	height: control.height
	sourceComponent: control.editable ? txtBgComponent : btnBgComponent

	Binding {target: loader.item; property: "implicitWidth"; value: ControlsSettings.longWidth}
	Component {id: btnBgComponent; ButtonBackground{}}
	Component {id: txtBgComponent; TextFieldBackground{}}
}
