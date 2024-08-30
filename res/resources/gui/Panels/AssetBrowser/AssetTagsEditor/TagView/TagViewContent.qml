import QtQuick 2.10
import WGTools.Controls 2.0

ListView {
	implicitWidth: contentWidth
	implicitHeight: contentHeight
	snapMode: ListView.SnapToItem
	boundsBehavior: Flickable.StopAtBounds
	keyNavigationWraps: true
	clip: true

	model: control.contentModel
	currentIndex: control.currentIndex

	// Looks like we have an issue when delegates are recreated dynamically #WOTD-136856
	// Use long cache buffer to instantiate every delegate at once
	IntValidator { id: validator }
	cacheBuffer: validator.top

	ScrollBar.vertical: ScrollBar {}
}
