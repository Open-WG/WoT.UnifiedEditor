import QtQuick 2.7

import Controls 1.0 as SMEControls

SMEControls.Text {
	text: control.displayText
	font: control.font
	horizontalAlignment: Text.AlignLeft
	verticalAlignment: Text.AlignVCenter
	elide: Text.ElideRight

	visible: text
	opacity: !control.enabled || control.visualFocus || control.highlighted
		? 1
		: 0.7

	color: control.enabled
		? "#000000"
		: "#ffffff"
}
