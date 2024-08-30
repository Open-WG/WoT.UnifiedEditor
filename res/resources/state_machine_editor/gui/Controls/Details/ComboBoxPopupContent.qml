import QtQuick 2.7
import QtQuick.Controls 2.3

ListView {
	id: listview
	implicitHeight: contentHeight
	model: control.popup.visible ? control.delegateModel : null;
	currentIndex: control.highlightedIndex
	boundsBehavior: Flickable.StopAtBounds
	clip: true

	Connections {
		target: control.popup
		onOpened: listview.positionViewAtIndex(control.highlightedIndex, ListView.Center)
	}

	ScrollBar.vertical: ScrollBar {}
}
