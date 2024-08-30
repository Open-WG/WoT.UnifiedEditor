import QtQml.Models 2.2
import QtQuick 2.7
import QtQuick.Controls 1.4 as QtQuickControls1
import WGTools.QmlUtils 1.0

FocusScope {
	id: root

	// data
	property var model: null
	property var selectionModel: null
	property var contextMenu: null

	property string sortingRole: "display"
	property int sortingOrder: Qt.AscendingOrder

	property var tableColumnSize: table.getColumnSize()
	onTableColumnSizeChanged: {
		table.setColumnSize(tableColumnSize)
	}

	// appearance
	property real sizeMultiplier
	property bool sectionsEnabled: true
	
	property string quickSearchText: ""
	
	signal sotringRoleChanged(string role)
	signal pathSelected(string selectedPath)
	signal clicked()
	signal doubleClicked()

	activeFocusOnTab: false
	state: "grid"

	onSortingRoleChanged: {
		var columnIndex = p.getTableViewColumn(sortingRole)
		console.assert(columnIndex != -1, "Invalid role '" + sortingRole + "'")

		table.sortIndicatorColumn = columnIndex
		Qt.callLater(p.sortModel)
	}

	onSortingOrderChanged: {
		table.sortIndicatorOrder = sortingOrder
		Qt.callLater(p.sortModel)
	}

	Connections {
		target: table

		onSortIndicatorColumnChanged: {
			root.sortingRole = table.getColumn(table.sortIndicatorColumn).role
		}

		onSortIndicatorOrderChanged: {
			root.sortingOrder = table.sortIndicatorOrder
		}
	}

	function setViewMode(viewMode) {
		state = viewMode

		switch (state)
		{
			case "grid":
				grid.forceActiveFocus()
				break

			case "table":
				table.forceActiveFocus()
				break
		}
	}

	function getViewMode() {
		return state
	}

	onStateChanged: {
		p.selectionHeld = true
		selectionSyncTimer.restart()
	}

	Keys.onReturnPressed: {
		doubleClicked()
	}

	Keys.onEnterPressed: {
		doubleClicked()
	}
	
	Keys.onPressed: {
		if (StringUtils.isPrint(event.text))
		{
			quickSearchTimer.restart()
			quickSearchText += event.text
			event.accepted = true
		}
	}

	Component.onCompleted: {
		p.sortModel()
	}
	
	Timer {
		id: quickSearchTimer
		interval: 1000
		onTriggered: quickSearchText = ""
	}

	QtObject {
		id: p // private

		property bool selectionSyncing: false
		property bool selectionHeld: false

		function syncViewsSelection() {
			if (selectionSyncing)
				return

			if (root.selectionModel === null)
				return

			selectionSyncing = true

			switch (state)
			{
			case "grid":
				grid.currentIndex = root.selectionModel.currentIndex.row
				break

			case "table":
				if (root.selectionModel.currentIndex.row == -1)
				{
					table.selection.clear()
					table.currentRow = -1
				}
				else
				{
					var row = root.selectionModel.currentIndex.row
					table.currentRow = row
					table.selection.select(row, row)
				}
				break
			}

			selectionSyncing = false
		}

		function syncModelSelection(row) {
			if (selectionSyncing)
				return

			if (root.selectionModel === null)
				return

			selectionSyncing = true

			var index = root.model.index(row, 0)
			root.selectionModel.setCurrentIndex(index, ItemSelectionModel.SelectCurrent)

			selectionSyncing = false
		}

		function sortModel() {
			if (root.model != null)
			{
				var order = []
				if (root.sortingRole != 'isDirectory') {
					order.push({ role: 'isDirectory', order: Qt.DescendingOrder })
				}
				order.push({ role: root.sortingRole, order: root.sortingOrder })

				root.model.sort(order)
			}
		}

		function getTableViewColumn(role) {
			for (var columnIndex = 0; columnIndex < table.columnCount; ++columnIndex)
			{
				var column = table.getColumn(columnIndex)
				if (column.role == role)
					return columnIndex
			}

			return -1
		}
	}

	// shit stuff
	Connections {
		target: selectionModel

		onCurrentChanged: {
			p.syncViewsSelection()
		}
	}

	Timer {
		id: selectionSyncTimer
		interval: 0

		onTriggered: {
			p.selectionHeld = false
			p.syncViewsSelection()
		}
	}

	// views
	ContentGrid {
		id: grid
		activeFocusOnTab: true
		iconSizeFactor: root.sizeMultiplier
		visible: false
		enabled: false
		contextMenu: root.contextMenu

		anchors.fill: parent

		onClicked: {
			root.clicked()
		}

		onDoubleClicked: {
			root.doubleClicked()
		}

		onCurrentIndexChanged: {
			if (p.selectionHeld == false)
			{
				p.syncModelSelection(currentIndex)
			}
		}
	}

	ContentTable {
		id: table
		activeFocusOnTab: true
		selectionMode: QtQuickControls1.SelectionMode.SingleSelection
		sectionsEnabled: root.sectionsEnabled
		rowSize: root.sizeMultiplier
		contextMenu: root.contextMenu
		visible: false
		enabled: false

		anchors.fill: parent

		onPathSelected: {
			root.pathSelected(selectedPath)
		}

		onClicked: {
			root.clicked()
		}

		onDoubleClicked: {
			root.doubleClicked()
		}

		onCurrentRowChanged: {
			if (p.selectionHeld == false)
			{
				p.syncModelSelection(currentRow)
			}
		}
	}

	states: [
		State {
			name: "grid"

			PropertyChanges {
				target: grid
				model: root.model
				visible: true
				enabled: true
				focus: true
			}
		},

		State {
			name: "table"

			PropertyChanges {
				target: table
				model: root.model
				visible: true
				enabled: true
				focus: true
			}
		}
	]
}
