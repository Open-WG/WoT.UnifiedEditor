import QtQuick 2.10
import WGTools.Controls 2.0
import WGTools.Views.Details 1.0 as ViewDetails

Control {
	id: control

	property real size: 0
	property real minHeight: 26
	property real maxHeight: 160

	height: minHeight + size * (maxHeight - minHeight)
	hoverEnabled: true

	Accessible.name: model && model.hasOwnProperty("display") ? model.display : ""

	background: ViewDetails.RowDelegate {
		readonly property color backgroundColor: _palette.color8
		readonly property color alternateBackgroundColor: _palette.color6

		height: control.height
		hovered: control.hovered
	}
}
