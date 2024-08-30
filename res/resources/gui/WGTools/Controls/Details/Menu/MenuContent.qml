import QtQuick 2.11
import WGTools.Controls 2.0

ListView {
	implicitHeight: contentHeight
	snapMode: ListView.SnapToItem
	boundsBehavior: Flickable.StopAtBounds
	clip: true

	model: control.contentModel
	currentIndex: control.currentIndex

	ScrollIndicator.vertical: ScrollIndicator {}
}
