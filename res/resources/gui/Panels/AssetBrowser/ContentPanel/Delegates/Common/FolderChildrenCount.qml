import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

Misc.Text {
	property int value: 0

	size: "Small"
	enabled: false
	color: _palette.color3
	text: value + (value == 1 ? " item" : " items")
}
