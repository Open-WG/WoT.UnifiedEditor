import QtQuick 2.10
import WGTools.Controls.Details 2.0 as Details
import WGTools.Misc 1.0 as Misc

Details.ButtonBackground {
	Misc.CheckerboardRectangle {
		id: checkerboard
		width: parent.width
		height: parent.height
		radius: parent.radius
		opacity: control.enabled ? 1 : 0.5
		z: -1
	}
}
