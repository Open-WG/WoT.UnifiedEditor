import QtQuick 2.11
import WGTools.Controls 2.0

ListView {
	id: listview
	implicitHeight: contentHeight
	model: control.popup.visible ? control.delegateModel : null
	currentIndex: control.highlightedIndex
	boundsBehavior: Flickable.StopAtBounds
	clip: true

	Connections {
		target: control.popup
		onOpened: listview.positionViewAtIndex(control.highlightedIndex, ListView.Center)
	}

	ScrollBar.vertical: ScrollBar {}
}
