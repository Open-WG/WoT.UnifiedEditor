import QtQuick 2.10
import WGTools.Controls 2.0
import QtQml.Models 2.2
import "ViewsSettings.js" as ViewsSettings

Item {
	id: helper

	property int horizontalScrollBarPolicy: parent ? parent.horizontalScrollBarPolicy : ScrollBar.AsNeeded
	property int verticalScrollBarPolicy: parent ? parent.verticalScrollBarPolicy : ScrollBar.AsNeeded

	property real leftPadding: 0
	property real rightPadding: 0
	property real topPadding: 0
	property real bottomPadding: 0

	property real availableWidth
	property real availableHeight
	property real contentWidth
	property real contentHeight

	property bool __blockUpdates: false
	property bool __recursionGuard: false
	property bool __isShortcutPressed: false

	anchors.fill: parent
	Accessible.ignored: true
	function doLayout() {
		if (flickableItem !== null) {
			flickableItem.contentX = Math.max(0, Math.min(flickableItem.contentX, contentWidth - width))
		}
		if (!__recursionGuard) {
			__recursionGuard = true
			__blockUpdates = true

			helper.contentWidth = flickableItem !== null ? flickableItem.contentWidth : 0
			helper.contentHeight = flickableItem !== null ? flickableItem.contentHeight : 0
			helper.availableWidth = viewport.width
			helper.availableHeight = viewport.height

			__blockUpdates = false
			__recursionGuard = false
		}
	}

	Connections {
		target: viewport
		onWidthChanged: doLayout()
		onHeightChanged: doLayout()
	}

	Connections {
		target: flickableItem
		onContentWidthChanged: doLayout()
		onContentHeightChanged: doLayout()
		onContentXChanged: hscrollbar.flash()
		onContentYChanged: vscrollbar.flash()
	}

	Binding { target: helper.parent.__scroller.horizontalScrollBar; property: "visible"; value: false }
	Binding { target: helper.parent.__scroller.verticalScrollBar; property: "visible"; value: false }
	Binding {
		delayed: true
		target: helper.parent.__scroller;
		property: "horizontalScrollbarOffset";
		value: hscrollbar.visible ? hscrollbar.height +  helper.parent.__scroller.scrollBarSpacing + ViewsSettings.scrollbarIndent : 0
	}
	Binding {
		delayed: true
		target: helper.parent.__scroller;
		property: "verticalScrollbarOffset";
		value: vscrollbar.visible ? vscrollbar.width +  helper.parent.__scroller.scrollBarSpacing + ViewsSettings.scrollbarIndent : 0
	}

	Shortcut {
		sequence: "end"
		onActivated: {
			__isShortcutPressed = true
			if(__listView.count != 0){
				if(__viewTypeName == "TreeView"){
					__currentRow = __listView.count - 1
					parent.selection.select(currentIndex, ItemSelectionModel.ClearAndSelect)
					positionViewAtEnd()
				}
				else if(__viewTypeName == "TableView"){
					parent.selection.deselect(currentRow)
					__currentRow = __listView.count - 1
					parent.selection.select(currentRow)
					parent.positionViewAtRow(currentRow)
				
				}
			}
			__isShortcutPressed = false
		}
		enabled: parent.activeFocus
	}
	Shortcut {
		sequence: "home"
		onActivated: {
			__isShortcutPressed = true
			if(__listView.count != 0){
				if(__viewTypeName == "TreeView"){
					__currentRow = 0
					parent.selection.select(currentIndex, ItemSelectionModel.ClearAndSelect)
					positionViewAtBeginning()
				}
				else if(__viewTypeName == "TableView"){
					parent.selection.deselect(currentRow)
					__currentRow = 0
					parent.selection.select(currentRow)
					parent.positionViewAtRow(currentRow)
				
				}
			}
			__isShortcutPressed = false
			
		}
		enabled: parent.activeFocus
	}
	Shortcut {
		sequence: "page down"
		onActivated: {
			__isShortcutPressed = true
			if(__viewTypeName == "TreeView"){
				scrollView(true,true)
			}
			else{
				scrollView(true,false)
			}
			__isShortcutPressed = false
		}
		enabled: parent.activeFocus
	}
	Shortcut {
		sequence: "page up"
		onActivated: {
			__isShortcutPressed = true
			if(__viewTypeName == "TreeView"){
				scrollView(false,true)
			}
			else{
				scrollView(false,false)
			}
			__isShortcutPressed = false
		}
		enabled: parent.activeFocus
	}

	function positionViewAt(isTreeView, isDown){
		if(isTreeView){
			positionViewAtIndex(currentIndex, isDown ? ListView.Beginning : ListView.End)
		}
		else{
			positionViewAtRow(__currentRow, isDown ? ListView.Beginning : ListView.End)
		}
	}

	function getBoundaryVisibleRow(isLast){
		var boundaryVisibleRow = -1
		var maybeYBoundaryVisibleRow = 0
		var __headerHeight = 0
		
		if(typeof headerHeight !== "undefined" && headerVisible && headerDelegate != null){
			__headerHeight = headerHeight
		}
		var epsilon = 0.5
		if(isLast){
			maybeYBoundaryVisibleRow = flickableItem.contentY + height
			do{
				maybeYBoundaryVisibleRow -= rowHeight
				if(maybeYBoundaryVisibleRow > flickableItem.contentY + __headerHeight){
					boundaryVisibleRow = __listView.indexAt(0, maybeYBoundaryVisibleRow + epsilon)
				}
			}while(boundaryVisibleRow == -1 && maybeYBoundaryVisibleRow > flickableItem.contentY + __headerHeight)
		}
		else{
			maybeYBoundaryVisibleRow = flickableItem.contentY + __headerHeight
			do{
				maybeYBoundaryVisibleRow += rowHeight
				if(maybeYBoundaryVisibleRow < flickableItem.contentY + height){
					boundaryVisibleRow = __listView.indexAt(0, maybeYBoundaryVisibleRow - epsilon)
				}
			}while(boundaryVisibleRow == -1 && maybeYBoundaryVisibleRow < flickableItem.contentY + height)
		}

		return boundaryVisibleRow
	}

	function crementing(isDown){
		if(isDown){
			__listView.incrementCurrentIndexBlocking()
		}
		else{
			__listView.decrementCurrentIndexBlocking()
		}
	}
	function scrollView(isDown, isTreeView){
		if(__listView.count == 0){
			return;
		}
		if(!isTreeView && selection){
			selection.deselect(__currentRow)
		}
		var firstVisibleRow = getBoundaryVisibleRow(false)
		var lastVisibleRow = getBoundaryVisibleRow(true)
	
		var boundaryVisibleRow = isDown ? lastVisibleRow: firstVisibleRow
		var isRowInViewport = firstVisibleRow <= __currentRow && lastVisibleRow >= __currentRow ? true: false
		if(firstVisibleRow == lastVisibleRow){
			crementing(isDown)
			positionViewAt(isTreeView, !isDown)
		}
		else {
			if(boundaryVisibleRow == __currentRow || !isRowInViewport){
				positionViewAt(isTreeView, isDown)
			}
			boundaryVisibleRow = getBoundaryVisibleRow(isDown)
			if(boundaryVisibleRow == -1 || boundaryVisibleRow == __currentRow){
				crementing(isDown)
				positionViewAt(isTreeView, !isDown)
			}
			else{
				__currentRow = boundaryVisibleRow
			}
		}
		if(selection) {
			if(isTreeView){
				selection.select(currentIndex, ItemSelectionModel.ClearAndSelect)
			}
			else{
				selection.select(__currentRow)
			}
		}
	}

	ScrollBar {
		id: hscrollbar
		orientation: Qt.Horizontal
		policy: helper.horizontalScrollBarPolicy//ScrollBar.AsNeeded
		visible: policy === ScrollBar.AsNeeded ? size < 1.0 : policy == ScrollBar.AlwaysOn

		property bool moving: false

		anchors.bottom: helper.bottom
		anchors.left: helper.left
		anchors.right: helper.right
		anchors.bottomMargin: helper.bottomPadding
		anchors.leftMargin: helper.leftPadding
		anchors.rightMargin: helper.rightPadding

		onPositionChanged: {
			if (flickableItem && !helper.__blockUpdates && pressed) {
				flickableItem.contentX = (position * helper.contentWidth) + flickableItem.originX
			}
		}

		onMovingChanged: {
			updateActive()
		}

		function flash() {
			moving = true
			hFlasher.restart()
		}

		function updateActive() {
			return pressed || hovered || moving
		}

		Binding on position {
			when: !hscrollbar.pressed && !helper.__blockUpdates
			value: (flickableItem.contentX - flickableItem.originX) / helper.contentWidth
		}

		Binding on size {
			when: !helper.__blockUpdates
			value: helper.availableWidth / helper.contentWidth
		}

		Timer {
			id: hFlasher
			interval: 10
			onTriggered: hscrollbar.moving = false
		}
	}

	ScrollBar {
		id: vscrollbar
		orientation: Qt.Vertical
		policy: helper.verticalScrollBarPolicy
		visible: policy === ScrollBar.AsNeeded ? size < 1.0 : policy == ScrollBar.AlwaysOn

		property bool moving: false

		anchors.bottom: helper.bottom
		anchors.right: helper.right
		anchors.top: helper.top
		anchors.bottomMargin: helper.bottomPadding
		anchors.rightMargin: helper.rightPadding
		anchors.topMargin: helper.topPadding + __scrollBarTopMargin

		onPositionChanged: {
			if (flickableItem && !helper.__blockUpdates && (__isShortcutPressed || pressed)) {
				flickableItem.contentY = (position * helper.contentHeight) + flickableItem.originY
			}
		}

		onMovingChanged: {
			updateActive()
		}

		function flash() {
			moving = true
			vFlasher.restart()
		}

		function updateActive() {
			active = pressed || hovered || moving
		}

		Binding on position {
			when: !vscrollbar.pressed && !helper.__blockUpdates
			value: (flickableItem.contentY - flickableItem.originY) / helper.contentHeight
		}

		Binding on size {
			when: !helper.__blockUpdates
			value: helper.availableHeight / helper.contentHeight
		}

		Timer {
			id: vFlasher
			interval: 10
			onTriggered: vscrollbar.moving = false
		}
	}
}
