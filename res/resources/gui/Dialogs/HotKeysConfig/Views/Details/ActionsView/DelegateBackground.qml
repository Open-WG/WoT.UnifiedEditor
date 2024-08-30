import QtQuick 2.11
import WGTools.Views.Details 1.0

RowDelegate {
	implicitHeight: 24
	height: 24

	property QtObject styleData: QtObject {
		readonly property bool alternate: false
		readonly property bool hasActiveFocus: control.activeFocus
		readonly property bool hovered: control.hovered
		readonly property bool selected: control.highlighted
	}
}
