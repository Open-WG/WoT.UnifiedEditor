import QtQuick 2.11
import WGTools.Controls.Details 2.0
import WGTools.Misc 1.0 as Misc

Item {
	id: label
	width: childrenRect.width
	height: control.availableHeight
	x: control.width - control.padding - width
	y: control.topPadding
	opacity: !control.buttonsVisible
	visible: opacity && control.units.length

	Misc.Text {
		text: control.units
		horizontalAlignment: TextInput.AlignLeft
		verticalAlignment: TextInput.AlignVCenter
		color: _palette.color3
		size: "Small"

		anchors.bottom: label.bottom
		anchors.bottomMargin: 2
	}

	NumberBehavior on opacity {}
}
