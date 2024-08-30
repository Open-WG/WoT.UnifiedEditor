import QtQuick 2.7
import QtGraphicalEffects 1.0
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Clickomatic 1.0 as Clickomatic
import WGTools.Resources 1.0 as WGTResources
import "Delegates/Grid" as Delegates

GridView {
	id: grid

	property real iconSizeMin: 64
	property real iconSizeMax: 196
	property real iconSizeFactor: 0
	property var contextMenu
	property bool technicalNameDisplayed: true

	Accessible.name: "Grid"

	signal clicked(int index)
	signal doubleClicked(int index)
	cellWidth: blankDelegate.width
	cellHeight: blankDelegate.height
	cacheBuffer: cellHeight * 1.5
	boundsBehavior: Flickable.StopAtBounds
	maximumFlickVelocity: ControlsSettings.mouseWheelScrollVelocity
	pixelAligned: true
	focus: true

	onCellHeightChanged: Qt.callLater(updateScroll)
	onCountChanged: Qt.callLater(updateScroll)
	onCurrentIndexChanged: Qt.callLater(updateScroll)

	function updateScroll() {
		if (currentIndex != -1) {
			positionViewAtIndex(currentIndex, GridView.Contain)
		}
	}

	function showPopupMenu() {
		let menu = grid.contextMenu.createObject(grid)
		menu.popupEx()
	}
	
	Keys.onMenuPressed: {
		// to prevent propogation to other items
		event.accepted = true
	}

	Keys.onReleased: {
		if(Qt.Key_Menu == event.key && !event.isAutoRepeat)
		{
			showPopupMenu()
			event.accepted = true
		}
	}

	delegate: Delegates.DelegateLoader {
		id: loader
		width: cellWidth
		height: cellHeight
		text: {
			(technicalNameDisplayed || model.localizationName.length == 0) ? model.display : model.localizationName
		}

		property QtObject styleData: QtObject {
			readonly property bool hovered: mouseArea.containsMouse
			readonly property bool selected: index == grid.currentIndex
			readonly property bool hasActiveFocus: selected && activeFocus
		}

		ToolTip.text: model.display
		ToolTip.visible: mouseArea.containsMouse
		ToolTip.delay: ControlsSettings.tooltipDelay
		ToolTip.timeout: ControlsSettings.tooltipTimeout

		Connections {
			target: grid.model
			onDataChanged: { 
				if( index >= topLeft.row && index <= bottomRight.row ) {
					loader.sourceChanged()
				}
			} 
		}

		MouseArea {
			id: mouseArea

			hoverEnabled: true
			acceptedButtons: Qt.LeftButton | Qt.RightButton
			anchors.fill: parent

			onPressed: {
				grid.forceActiveFocus()
				grid.currentIndex = index

				if ("assetPath" in item) {
					dragItem.files = item.assetPath
					dragItem.icon = item.icon
					dragItem.active = Qt.binding(function() { return drag.active; })
					drag.target = dragItem
				}
				else {
					drag.target = null
				}
			}

			onReleased: {
				if (mouse.button == Qt.RightButton && grid.contextMenu) {
					showPopupMenu()
				}
			}

			function sleep(duration) { // In milliseconds
				var timeStart = new Date().getTime();

				while (new Date().getTime() - timeStart < duration) {
				// Do nothing
				}
			}

			onClicked: {
				//sleep(1000)
				grid.clicked(index)
			}

			onDoubleClicked: {
				if (mouse.button == Qt.LeftButton) {
					grid.doubleClicked(index)
				}
			}
		}
	}

	DragItem {
		id: dragItem
	}

	// In order to calculate proper cell size
	Delegates.FolderDelegate {
		id: blankDelegate
		visible: false
		enabled: false

		property real iconSize: grid.iconSizeMin + (grid.iconSizeMax - grid.iconSizeMin)*grid.iconSizeFactor

		property QtObject model: QtObject {
			readonly property string display: "Very long file or directory name"
			readonly property bool isFavorite: true
			readonly property int childrenCount: 1000
		}

		property QtObject styleData: QtObject {
			readonly property bool hovered: true
			readonly property bool selected: false
		}
	}

	Clickomatic.ClickomaticItem.showChild: function(childName) {
		var index = grid.model.indexOf(childName)
		grid.positionViewAtIndex(index, GridView.Contain)
	}

	ScrollBar.vertical: ScrollBar {
		id: vscrollbar
		visible: size < 1
		Rectangle{
			color: _palette.color8
			anchors.fill: parent
		}
	}
	
	function getBoundaryVisibleRow(isFirst){
		var eps = 0.01
		var boundaryVisibleRow = -1
		if(!isFirst){
			boundaryVisibleRow = Math.floor(eps + (contentY+height)/cellHeight)-1
		}
		else{
			if(Math.abs(contentY/cellHeight - Math.floor(contentY/cellHeight)) < eps){
				boundaryVisibleRow = Math.floor(contentY/cellHeight)
			}
			else{
				boundaryVisibleRow = Math.ceil(contentY/cellHeight)
			}
		}
		return boundaryVisibleRow
	}

	function scrollVertical(isDown){
		var eps = 0.01
		var goToIndex = -1
		var columns = Math.floor(width/cellWidth)
		var rows = Math.floor((count-1)/columns)
		var columnsShift = isDown ? columns : -columns
		var rowsViewport = Math.floor(height/cellHeight)
		var selectedItemRow = Math.floor(currentIndex/columns)
		var firstVisibleRow = getBoundaryVisibleRow(true)
		var lastVisibleRow = getBoundaryVisibleRow(false)
		var boundaryVisibleRow = Math.min(isDown ? lastVisibleRow : firstVisibleRow, rows)
		var isRowInViewport = false
		
		if (firstVisibleRow <= selectedItemRow && lastVisibleRow >= selectedItemRow) {
			isRowInViewport = true
		}
		else {
			isRowInViewport = false
		}
		if (rowsViewport <= 1) {
			goToIndex = currentIndex + columnsShift
		}
		else {
			if (!isRowInViewport || boundaryVisibleRow == selectedItemRow) {
				positionViewAtIndex(currentIndex , isDown ? GridView.Beginning : GridView.End)
				boundaryVisibleRow = isDown ? getBoundaryVisibleRow(false) : getBoundaryVisibleRow(true)
			}
			if (boundaryVisibleRow != selectedItemRow){
				goToIndex = currentIndex%columns + boundaryVisibleRow*columns
				positionViewAtIndex(goToIndex , GridView.Contain)
			}
			else {
				goToIndex = currentIndex + columnsShift
			}
		}
		
		if (goToIndex < count && goToIndex >= 0) {
			currentIndex = goToIndex
		}
		else {
			if (isDown) {
				currentIndex = count - 1
			}
			else {
				currentIndex = 0
			}
		}
	}

	Shortcut {
		sequence: "end"
		onActivated: {
			currentIndex = count - 1
		}
		enabled: grid.activeFocus
	}
	Shortcut {
		sequence: "home"
		enabled: grid.activeFocus
		onActivated: {
			currentIndex = 0
		}
	}
	Shortcut {
		sequence: "page down"
		enabled: grid.activeFocus
		onActivated: scrollVertical(true)
	}
	Shortcut {
		sequence: "page up"
		enabled: grid.activeFocus
		onActivated: scrollVertical(false)
	}

}
