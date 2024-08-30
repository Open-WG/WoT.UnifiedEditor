import QtQuick 2.11
import QtQuick.Controls 1.4
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0
import WGTools.Controls.impl 1.0
import WGTools.Views 1.0 as Views
import WGTools.Misc 1.0 as Misc
import "Delegates/Table" as Delegates
import "Modes/Table/Details" as Details

import QtQml.StateMachine 1.11 as SM

Views.TableView {
	id: table
	__wheelAreaScrollSpeed: ControlsSettings.mouseWheelScrollVelocity2

	property alias contextMenu: contextMenuArea.menuComponent
	property bool sectionsEnabled
	property real rowSize

	property real minHeight: 26
	property real maxHeight: 160
	readonly property real rowHeight: minHeight + rowSize * (maxHeight - minHeight)

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
		height: table.rowHeight
	}

	onRowSizeChanged: {
		if (table.currentRow != -1) {
			table.positionViewAtRow(table.currentRow, ListView.Contain)
		}
	}

	// State Machine to set minimum size for "Name" column
	SM.StateMachine {
		initialState: abRoot.settings.tableViewState == "custom" ? customState : relativeState
		running: true

		SM.State {
			id: relativeState
			initialState: relativeInitingState

			property bool muted: false

			function update() {
				muted = true
				nameColumn.width = Math.max(customState.minWidth, table.viewport.width * 0.3)
				muted = false
			}

			onEntered: {
				abRoot.settings.tableViewState = "relative"
				update()
			}

			SM.State {
				id: relativeInitingState
				SM.TimeoutTransition {
					targetState: relativeInitedState
					timeout: 0
				}
			}

			SM.State {
				id: relativeInitedState

				SM.SignalTransition {
					targetState: customState
					signal: nameColumn.widthChanged
					guard: !relativeState.muted
				}

				SM.SignalTransition {
					targetState: customState
					signal: table.rowSizeChanged
				}
			}

			Connections {
				enabled: relativeState.active
				target: table.viewport
				onWidthChanged: relativeState.update()
			}
		}

		SM.State {
			id: customState

			readonly property real minWidth: 2*table.rowHeight

			function update() {
				nameColumn.width = Math.max(nameColumn.width, minWidth)
			}

			onEntered: {
				abRoot.settings.tableViewState = "custom"
				update()
			}

			Connections {
				target: table
				onRowHeightChanged: customState.update()
				enabled: customState.active
			}

			Connections {
				target: nameColumn
				onWidthChanged: customState.update()
				enabled: customState.active
			}
		}
	}
	
	function showPopupMenu() {
		let menu = contextMenu.createObject(table)
		menu.popupEx()
	}

	Keys.onReturnPressed: doubleClicked(null)
	Keys.onEnterPressed: doubleClicked(null)
	
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
		id: nameColumn
		role: "display"
		title: "Name"

		delegate: Delegates.Display {
			id: loader

			Binding on ActiveFocus.when {
				value: styleData.row == table.currentRow && table.currentRow != -1
				delayed: true
			}
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
		role: "localizationName"
		title: "Localization name"
		width: table.viewport.width * 0.1

		delegate: Delegates.Extension {
			text: model != null ? model.localizationName : ""
		}
	}

	TableViewColumn {
		role: "tags"
		title: "Tags"
		width: table.viewport.width * 0.3
		delegate: Delegates.Tags {}
	}

	TableViewColumn {
		role: "extension"
		title: "Extension"
		width: table.viewport.width * 0.1
		delegate: Delegates.Extension {}
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

				if (w <= 0)
					continue

				if (table.__columns[i].width == w)
					continue

				table.__columns[i].width = w
			}
		}
	}

	onHeaderMenuRequested: headerMenu.popupEx()

	Controls.Menu {
		id: headerMenu

		Instantiator {
			model: table.columnCount

			onObjectAdded: {
				if (table.getColumn(index).title != "Name")
					headerMenu.insertItem(index, object)
			}
			onObjectRemoved: headerMenu.removeItem(object)

			Controls.MenuItem {
				readonly property var column: table.getColumn(index)

				text: column ? column.title : ""
				onClicked: column.visible = !column.visible

				Binding on checked {
					value: column && column.visible
				}
			}
		}
	}
}
