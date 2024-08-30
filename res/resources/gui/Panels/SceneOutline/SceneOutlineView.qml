import QtQuick 2.11
import QtQuick.Controls 1.4 as QuickControls
import QtQml.Models 2.11
import WGTools.Clickomatic 1.0 as Clickomatic
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Controls.impl 1.0
import WGTools.Misc 1.0 as Misc
import WGTools.Views 1.0 as Views
import WGTools.Views.Details 1.0 as ViewDetails
import WGTools.Views.Styles 1.0 as ViewStyles
import "Delegates" as Delegates
import "Settings.js" as LocalSettings

Views.TreeView {
	id: view

	property var sceneOutlineContext: context
	property bool useExtraColumns: (sceneOutlineContext.columnsModel != undefined && sceneOutlineContext.columnsModel != null)

	headerVisible: useExtraColumns
	sortIndicatorVisible: true
	accesibleNameRole: nameColumn.role
	__wheelAreaScrollSpeed: ControlsSettings.mouseWheelScrollVelocity2

	onSortIndicatorColumnChanged: {
		sort()
	}

	onSortIndicatorOrderChanged: {
		sort()
	}

	Shortcut {
		sequence: StandardKey.SelectAll
		onActivated: {
			sceneOutlineContext.selectAll()
		}
	}

	function sort() {
		var roleName = view.getColumn(sortIndicatorColumn).role
		model.sortByRole(roleName, sortIndicatorOrder)
	}

	function updateSortIndicators() {
		if (model == null || model.sortRole == null || model.sortOrder == null) {
			return
		}
		var role = model.sortRole
		var order = model.sortOrder
		for (var i = 0; i < view.columnCount; i++) {
			var column = getColumn(i)
			if (column != null && model.roleByName(column.role) == role) {
				sortIndicatorColumn = i
				sortIndicatorOrder = order
				return
			}
		}
	}

	onModelChanged: {
	 	updateSortIndicators()
	}

	Connections {
		target: model
		ignoreUnknownSignals: true
		onSortingChanged: {
			updateSortIndicators()
		}
	}

	style: ViewStyles.TreeViewStyle {
		branchDelegate: ViewDetails.BranchDelegate {}
		rowDelegate: Delegates.RowDelegate {
			current: styleData.row == view.__currentRow
			onHoverChanged: sceneOutlineContext.syncHover(index)
			onHoverReset: sceneOutlineContext.resetHover()
		}
	}

	// column menu
	Menu {
		id: headerMenu

		background{
			implicitHeight: 0
		}

		MenuItem {
			text: "Edit Columns"
			onTriggered: sceneOutlineContext.showColumnsDialog()
		}
	}

	Component.onCompleted: {
		sceneOutlineContext.onShowItem.connect(function(index){
			view.expandAllParents(index)
			view.positionViewAtIndex(index, ListView.Center)
		})

		sceneOutlineContext.expandAllRequested.connect(function() { view.expandAll() })
		sceneOutlineContext.collapseAllRequested.connect(function() { view.collapseAll() })
	}

	onHeaderMenuRequested: {
		headerMenu.popupEx()
	}

	Keys.onPressed: {
		if (view.selection != undefined && (event.key == Qt.Key_Return || event.key == Qt.Key_Enter)) {
			sceneOutlineContext.onDoubleClicked(view.selection.currentIndex);
		}
	}

	onDoubleClicked: {
		if (index.valid) {
			view.toggleExpanded(index);
			sceneOutlineContext.onDoubleClicked(index);
		}
	}

	Connections {
		target: view.selection
		onSelectionChanged: {
			var indexes = view.selection.selectedIndexes
			if (indexes.length == 1) {
				lookAtIndex(indexes[0])
			}
		}
	}

	 function lookAtIndex(index) {
		if (index.valid) {
			view.expandAllParents(index)
			view.positionViewAtIndex(index, ListView.Contain)
		} else {
			view.positionViewAtBeginning()
		}
	}

	QuickControls.TableViewColumn {
		id: nameColumn
		resizable: true
		horizontalAlignment: Text.AlignLeft
		title: "Name"
		role: "display"

		delegate: Delegates.BaseDelegate {
		 	ActiveFocus.when: view.activeFocus && styleData.index == view.currentIndex

			// clickomatic --------------------------------
			Accessible.name: accesibleNameGenerator.value
			Clickomatic.TableAccesibleNameGenerator {
				id: accesibleNameGenerator
				role: view.accesibleNameRole
				modelIndex: styleData.index
			}
			// --------------------------------------------

			Component.onCompleted: {
				expandTimer.start()
			}

			Connections {
				target: styleData
				ignoreUnknownSignals: true

				onIsExpandedChanged: {
					if (model != undefined) {
						model.expanded = styleData.isExpanded
					}
				}

				onValueChanged: {
					expandTimer.start()
				}
			}

			Timer {
				id: expandTimer
				interval: 0
				onTriggered: {
					if (model != undefined && model.expanded) {
						view.expand(styleData.index)
					}
				}
			}

			Loader {
				width: parent.width
				height: parent.height
				sourceComponent: mouseAreaComponent
			}
		}
	}

	Component {
		id: mouseAreaComponent
		MouseArea {
			Accessible.ignored: true
			width: parent.width
			height: parent.height
			acceptedButtons: Qt.RightButton
			propagateComposedEvents: true
			onReleased: {
				// select
				if (view.selection) {
					var pos = mapToItem(view, mouseX, mouseY)
					let index = view.indexAt(pos.x, pos.y)
					if (index.valid) {
						if (!view.selection.isSelected(index)) {
							view.selection.select(index, ItemSelectionModel.SelectCurrent)
						}
						sceneOutlineContext.requestMenu()
					}
				}
				mouse.accepted = false
			}
		}
	}

	Component {
		id: columnComponent
		QuickControls.TableViewColumn {
			property var columnModel: null
			onWidthChanged: {
				columnModel.columnWidth = width
			}

			delegate: Loader {
				width: parent.width
				height: parent.height
				visible: styleData.value != undefined
				sourceComponent: columnModel != undefined && columnModel.type != undefined && columnModel.type == "bool"
					? checkBoxDelegate
					: textDelegate

				Loader {
					width: parent.width
					height: parent.height
					sourceComponent: mouseAreaComponent
				}

				Component {
					id: checkBoxDelegate
					CheckBox {
						id: checkControl
						checked: styleData.value != undefined ? styleData.value : false
						enabled: false
					}
				}

				Component {
					id: textDelegate
					Misc.Text {
						text: styleData.value != undefined ? styleData.value : ""
						elide: Text.ElideRight
						verticalAlignment: Text.AlignVCenter
						padding: 10
					}
				}
			}
		}
	}

	Instantiator {
		id: extraColumnsInstantiator
		model: useExtraColumns
			? sceneOutlineContext.selectedColumnsModel
			: null

		onObjectAdded: {
			var obj = columnComponent.createObject(null, {
				"columnModel": object.columnModel,
				"title": object.columnModel.fullName,
				"role": object.columnModel.columnString,
				"width": object.columnModel.columnWidth})

			object.source = obj
			view.insertColumn(index + 1, obj)
			updateColumnsTimer.start()
		}
		onObjectRemoved: {
			view.removeColumn(index + 1)
			updateColumnsTimer.start()
		}

		delegate: QtObject {
			property QtObject source: null
			property var columnModel: model
		}

		function findObject(columnName) {
			for (var i = 0; i < count; i++) {
				var object = objectAt(i)
				if (columnName == object.columnModel.display) {
					return object
				}
			}

			return null
		}
	}

	onColumnIndexChanged: {
		var col = getColumn(index)
		if (col != null) {
			var object = extraColumnsInstantiator.findObject(col.title)
			if (object != null) {
				object.columnModel.columnOrder = index
				updateColumnsTimer.start()
			}
		}
	}

	// Columns and instantiator model can move items, to need to sync them after structure has been changed
	Timer {
		id: updateColumnsTimer
		interval: 0
		onTriggered: {
			view.getColumn(0).__index = 0
			for (var i = 1; i < view.columnCount; i++) {
				var c = view.getColumn(i)
				var o = extraColumnsInstantiator.objectAt(i - 1)
				if (c != null && o != null) {
					c.__index = i
					c.columnModel = o.columnModel
				}
			}
		}
	}
}
