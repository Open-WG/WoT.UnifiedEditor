import QtQuick 2.11
import WGTools.Views.Details 1.0

RoundedRowDelegate {
	height: control.height

	readonly property QtObject styleData: QtObject {
		readonly property bool alternate: false
		readonly property bool hasActiveFocus: control.activeFocus
		readonly property bool current: elementSelection.current
		readonly property bool selected: elementSelection.selected
		readonly property bool hovered: control.hovered
	}
}
