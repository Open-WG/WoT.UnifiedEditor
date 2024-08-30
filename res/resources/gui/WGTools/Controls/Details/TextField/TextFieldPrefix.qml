import QtQuick 2.11
import WGTools.Controls 2.0

Label {
	id: prefix

	property bool concatenate: false

	height: control.height
	rightPadding: concatenate ? 0 : control.spacing
	verticalAlignment: control.verticalAlignment
	x: control.padding

	color: _palette.color3
	visible: text.length
}
