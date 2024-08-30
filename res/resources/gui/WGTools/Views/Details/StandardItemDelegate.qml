import QtQuick 2.11
import WGTools.Misc 1.0 as Misc

Misc.IconLabel {
	spacing: 5

	label.horizontalAlignment: styleData.textAlignment
	label.elide: styleData.elideMode
	label.text: styleData.value
	label.color: styleData.textColor
	label.anchors.verticalCenterOffset: 1
}
