import QtQuick 2.7
import QtQuick.Controls 1.4
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0
import WGTools.Controls.impl 1.0
import WGTools.Views 1.0 as Views
import WGTools.Misc 1.0 as Misc
import "Delegates/Table" as Delegates
import "Modes/Table/Details" as Details

Views.TableView {
	id: table
	__wheelAreaScrollSpeed: ControlsSettings.mouseWheelScrollVelocity2

	property alias contextMenu: contextMenuArea.menuComponent
	property bool sectionsEnabled
	property real rowSize

	signal pathSelected(string selectedPath)

	alternatingRowColors: false
	backgroundVisible: false
	sortIndicatorVisible: true

	section.property: "path"
	section.labelPositioning: ViewSection.CurrentLabelAtStart | ViewSection.InlineLabels
	section.delegate: table.sectionsEnabled ? sectionComponent : null;

	Accessible.name: "Table"

	rowDelegate: Details.RowDelegate {
		Accessible.ignored: true
		size: table.rowSize
	}

	onRowSizeChanged: {
		if (table.currentRow != -1) {
			table.positionViewAtRow(table.currentRow, ListView.Contain)
		}
	}

	Keys.onReturnPressed: doubleClicked(null)
	Keys.onEnterPressed: doubleClicked(null)

	Component {
		id: sectionComponent

		Delegates.Section {
			onPathSelected: {
				table.pathSelected(selectedPath)
			}
		}
	}

	Details.ContextMenuArea {
		id: contextMenuArea
	}

	DragItem {
		id: dragItem

		property var dataSource

		Connections {
			target: table.__mouseArea
			onPressed: {
				let row = table.rowAt(mouse.x, mouse.y)
				if (row != -1 && ("assetPath" in dragItem.dataSource)) {
					dragItem.files = dragItem.dataSource.assetPath
					dragItem.icon = dragItem.dataSource.icon
					dragItem.active = Qt.binding(function() { return table.__mouseArea.drag.active; })
					table.__mouseArea.drag.target = dragItem
				} else {
					table.__mouseArea.drag.target = null
				}
			}
		}
	}

	TableViewColumn {
		role: "display"
		title: "Name"
		width: table.viewport.width * 0.3
		delegate: Delegates.Display {
			id: loader

			ActiveFocus.when: styleData.row == table.currentRow && table.currentRow != -1
			ActiveFocus.onActivated: dragItem.dataSource = item
			
			Connections {
				target: table.model ? table.model : null
				ignoreUnknownSignals: true
				onDataChanged: { 
					if( styleData.row >= topLeft.row && styleData.row <= bottomRight.row ) {
						loader.sourceChanged()
					}
				} 
			}	
		}
	}

	TableViewColumn {
		role: "tags"
		title: "Tags"
		width: table.viewport.width * 0.4
		delegate: Delegates.Tags {}
	}

	TableViewColumn {
		role: "created"
		title: "Date of creation"
		width: table.viewport.width * 0.15
		delegate: Delegates.Date {}
	}

	TableViewColumn {
		role: "modified"
		title: "Date of change"
		width: table.viewport.width * 0.15
		delegate: Delegates.Date {}
	}

	function getColumnSize() {
		var sz = ""
		for (var i = 0; i < table.__columns.length; ++i) {
			if (table.__columns[i].role) {
				sz += (sz ? " " : "") + table.__columns[i].width
			}
		}
		return sz
	}

	function setColumnSize(sz) {
		var list = sz.split(" ")
		for (var i = 0, j = 0; i < table.__columns.length; ++i) {
			if (table.__columns[i].role) {
				var w = parseInt(list[j++])

				if (w == 0)
					continue

				if (table.__columns[i].width == w)
					continue

				table.__columns[i].width = w
			}
		}
	}
}
