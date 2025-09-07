import QtQuick 2.11
import QtQuick.Controls 1.4 as QuickControls
import QtQml.Models 2.11
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
	id: treeView

	property var sceneOutlineContext: context
	property bool useExtraColumns: (sceneOutlineContext != undefined && sceneOutlineContext.columnsModel != undefined && sceneOutlineContext.columnsModel != null)
	property bool sortable: false

	headerVisible: useExtraColumns
	sortIndicatorVisible: sortable
	__wheelAreaScrollSpeed: ControlsSettings.mouseWheelScrollVelocity2

	property var columnsSortingObject: sceneOutlineContext.columnsSortingObject

	rowDelegate: ViewDetails.DraggableRowDelegate {
		view: treeView
		reorderEnabled: true
	}

	onModelChanged: {
		sortable = (model && typeof model.sortByRole === "function")
		updateSortIndicators()
	}

	onSortIndicatorColumnChanged: {
		if (sortable) {
			sort()
		}
	}

	onSortIndicatorOrderChanged: {
		if (sortable) {
			sort()
		}
	}

	Shortcut {
		sequence: StandardKey.SelectAll
		onActivated: {
			sceneOutlineContext.selectAll()
		}
	}

	function sort() {
		var roleName = treeView.getColumn(sortIndicatorColumn).role
		model.sortByRole(roleName, sortIndicatorOrder)
	}

	function updateSortIndicators() {
		if (model == null || model.sortRole == null || model.sortOrder == null) {
			return
		}
		var role = model.sortRole
		var order = model.sortOrder
		for (var i = 0; i < treeView.columnCount; i++) {
			var column = getColumn(i)
			if (column != null && model.roleByName(column.role) == role) {
				sortIndicatorColumn = i
				sortIndicatorOrder = order
				return
			}
		}
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
			active: styleData.row == treeView.__currentRow
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
		sceneOutlineContext.onShowItem.connect(function(index) {
			treeView.expandAllParents(index)
			treeView.positionViewAtIndex(index, ListView.Center)
		})

		sceneOutlineContext.expandAllRequested.connect(function() { treeView.expandAll() })
		sceneOutlineContext.collapseAllRequested.connect(function() { treeView.collapseAll() })
	}

	onHeaderMenuRequested: {
		headerMenu.popupEx()
	}

	Keys.onPressed: {
		// to prevent propogation to other items
		if(Qt.Key_Menu == event.key) {
			event.accepted = true
		}
		else if (treeView.selection != undefined && (event.key == Qt.Key_Return || event.key == Qt.Key_Enter)) {
			sceneOutlineContext.onDoubleClicked(treeView.selection.currentIndex)
		}
	}

	Keys.onReleased: {
		if(Qt.Key_Menu == event.key && !event.isAutoRepeat)
		{
			sceneOutlineContext.requestMenu()
			event.accepted = true
		}
	}

	onDoubleClicked: {
		if (index.valid) {
			treeView.toggleExpanded(index);
			sceneOutlineContext.onDoubleClicked(index)
		}
	}

	Connections {
		target: treeView.selection
		onSelectionChanged: {
			var indexes = treeView.selection.selectedIndexes
			if (indexes.length == 1) {
				lookAtIndex(indexes[0])
			}
		}
	}

	 function lookAtIndex(index) {
		if (index.valid) {
			treeView.expandAllParents(index)
			treeView.positionViewAtIndex(index, ListView.Contain)
		} else {
			treeView.positionViewAtBeginning()
		}
	}

	QuickControls.TableViewColumn {
		id: nameColumn
		resizable: true
		horizontalAlignment: Text.AlignLeft
		title: "Name"
		role: "display"

		delegate: Delegates.BaseDelegate {
			Binding on ActiveFocus.when {
				value: treeView.activeFocus && styleData.row != -1 && styleData.index == treeView.currentIndex
				delayed: true
			}

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
						treeView.expand(styleData.index)
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
			onPressed: view.forceActiveFocus()
			onReleased: {
				// select
				if (treeView.selection) {
					var pos = mapToItem(treeView, mouseX, mouseY)
					let index = treeView.indexAt(pos.x, pos.y)
					if (index.valid) {
						if (!treeView.selection.isSelected(index)) {
							treeView.selection.select(index, ItemSelectionModel.SelectCurrent)
						}
						view.selection.setCurrentIndex(index, ItemSelectionModel.NoUpdate)

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
				sourceComponent: {
					if (columnModel == undefined) {
						return textDelegate
					}
					switch (columnModel.type) {
						case 'bool':
							return checkBoxDelegate
						case 'Vector2':
						case 'Vector3':
						case 'Vector4':
						    return vectorDelegate
						default:
							return textDelegate
					}
				}

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
					id: vectorDelegate
					Misc.Text {
						text: {
							if (styleData.value != undefined) {
								var result = []
								for (var prop in styleData.value) {
									result.push(Math.round(styleData.value[prop] * 1000) / 1000)
								}
								return result.join(", ")
							}
							else {
								return ""
							}
							
						}
						elide: Text.ElideRight
						verticalAlignment: Text.AlignVCenter
						padding: 10
					}
				}

				Component {
					id: textDelegate
					Misc.Text {
						text: styleData.value != undefined ? styleData.value.toString() : ""
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

		onObjectAdded : {
			object.columnModel.columnOrder = index + 1
			var obj = columnComponent.createObject(null, {
				"columnModel": object.columnModel,
				"title" : object.columnModel.fullName,
				"role" : object.columnModel.columnString,
				"width" : object.columnModel.columnWidth})

			object.source = obj
			treeView.insertColumn(index + 1, obj)
			updateColumnsTimer.start()
		}
		onObjectRemoved: {
			treeView.removeColumn(index + 1)
			updateColumnsTimer.start()
		}

		delegate : QtObject {
			property QtObject source : null
			property var columnModel : model
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
		interval : 0
		onTriggered : {
			treeView.getColumn(0).__index = 0
			for (var i = 1; i < treeView.columnCount; i++) {
				var c = treeView.getColumn(i)
				var o = extraColumnsInstantiator.objectAt(i - 1)
				if (c != null && o != null) {
					c.__index = i
					c.columnModel = o.columnModel
				}
			}
		}
	}
}
