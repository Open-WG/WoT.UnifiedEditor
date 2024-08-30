import QtQuick 2.11
import WGTools.Views.Details 1.0 as ViewDetails

ViewDetails.RowDelegate {
	current: styleData.row == view.__currentRow
	hovered: styleData.row == view.__hoverRow
	
	MouseArea {
		id: mouseArea
		width: parent.width
		height: parent.height
		hoverEnabled: true
		acceptedButtons: Qt.NoButton
		enabled: styleData.row >= 0
		onEntered: view.__hoverRow = styleData.row
		onExited: view.__hoverRow = -1
	}
}
