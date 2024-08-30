import QtQuick 2.7
import QtQuick.Templates 2.2 as T
import WGTools.Controls.Controllers 1.0

T.Slider {
	id: control

	property var model: null
	property int decimals: 0
	property string units: ""

	signal modified(bool commit)

	Accessible.name: "Slider"

	implicitWidth: background.implicitWidth
	implicitHeight: background.implicitHeight
	to: 0
	
	background: CameraSliderBackground {
		// TODO: workaround - WOTD-133405
		width: control.width
	}

	Keys.forwardTo: controller
	SliderController {
		id: controller
		onModified: control.modified(commit)
	}
}
