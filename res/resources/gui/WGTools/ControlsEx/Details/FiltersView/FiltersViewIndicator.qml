import QtQuick 2.11
import WGTools.Controls 2.0

Button {
	width: Math.min(implicitWidth, control.availableWidth)
	x: control.padding
	y: control.topPadding
	text: "Filters"
	onClicked: control.popup.open()
}
