import QtQuick 2.11
import WGTools.Controls 2.0

Label {
	leftPadding: (control.indicator && !control.mirrored) ? control.indicator.width + (text ? control.spacing : 0) : 0
	rightPadding: (control.indicator && control.mirrored) ? control.indicator.width + (text ? control.spacing : 0) : 0
	horizontalAlignment: control.mirrored ? Text.AlignRight : Text.AlignLeft
	verticalAlignment: Text.AlignVCenter
	elide: Text.ElideRight
	visible: text
	color: control.enabled
		? control.visualFocus
			? _palette.color1
			: _palette.color2
		: _palette.color3

	text: {
		if (control.text.length == 0)
			return control.text
	
		var arrOnOff = control.text.split('|', 2);
		if (arrOnOff.length != 2)
			return control.text
	
		return control.checked ? arrOnOff[0] : arrOnOff[1]
	}
}
