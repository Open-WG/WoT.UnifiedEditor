import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

Label {
	property var value

	color: _palette.color1
	fontSizeMode: Text.VerticalFit
	minimumPixelSize: height
	padding: 0
	text: control.labels.textFromValue(value ? value : 0, control.locale, control.labels.decimals)

	NumberBehavior on opacity {}
	ControlBB {}
}
