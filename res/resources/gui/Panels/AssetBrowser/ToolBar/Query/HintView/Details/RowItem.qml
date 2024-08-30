import QtQuick 2.7
import WGTools.Views.Details 1.0 as Details

MouseArea {
	id: mouseArea
	property bool selected: false;
	hoverEnabled: true

	Details.RowDelegate {
		anchors.fill: parent

		property QtObject styleData: QtObject {
			readonly property bool selected: mouseArea.selected
			readonly property bool hovered: mouseArea.containsMouse
			readonly property bool alternate: false
		}
	}
}
