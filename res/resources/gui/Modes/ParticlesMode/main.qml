import QtQuick 2.10
import QtQml.Models 2.2
import QtQuick.Layouts 1.11
import QtQuick.Controls 1.4 as QuickControls
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Views 1.0 as Views
import WGTools.Views.Styles 1.0 as ViewStyles
import WGTools.Controls 2.0 as Controls
import WGTools.Views.Details 1.0 as ViewDetails
import WGTools.Misc 1.0 as Misc

import Panels.PropertyGrid.View 1.0
import WGTools.PropertyGrid 1.0
import WGTools.Debug 1.0

ControlsEx.Panel {
	id: root
	title: "Particle editor"
	layoutHint: "right"

	ColumnLayout {
		spacing: 20
		anchors.fill: parent

		PropertyGrid {
			Layout.fillWidth: true
			Layout.margins: 5

			model: PropertyGridModel {
				id: pgModel
				source: context.toolObject
				changesController: context.changesController
			}

			selection: ItemSelectionModel {
				model: pgModel
			}

			// disable pg's copy/paste
			copyAction.enabled: false
			pasteAction.enabled: false
		}

		Shortcut {
			sequence: StandardKey.Copy
			onActivated: {
				treeView.model.copyItems(treeView.selection.selectedRows())
			}
		}

		Shortcut {
			sequence: StandardKey.Paste
			onActivated: {
				treeView.model.pasteIntoItem(treeView.currentIndex)
			}
		}

		Shortcut {
			sequence: StandardKey.Delete
			onActivated: {
				treeView.model.removeItems(treeView.selection.selectedRows())
			}
		}

		Views.TreeView {
			id: treeView

			// Index of the item upon which the menu was invoked.
			property var __menuSourceIndex

			model: context.model
			selection: context.selectionModel
			selectionMode: QuickControls.SelectionMode.ExtendedSelection
			Layout.fillWidth: true
			Layout.fillHeight: true
			headerVisible: false

			// menu actions
			property Component menuComponent: Controls.Menu {}
			property Component actionComponent: Controls.Action {
				onTriggered: {
					treeView.model.invokeMenuAction(treeView.__menuSourceIndex, treeView.selection.selectedRows(), text)
				}
			}

			function showItemMenu(index) {

				// Remember the index of this item, we'll use it later, when user triggers menu action.
				treeView.__menuSourceIndex = index

				var actionNames = treeView.model.getMenuActions(treeView.selection.selectedRows())
				if (actionNames.length === 0) {
					// Don't show an empty menu.
					return
				}

				var contextMenu = menuComponent.createObject(treeView)

				actionNames.forEach(function(name) {
					if (name === '---') {
						contextMenu.addSeparator()
					}
					else {
						var action = actionComponent.createObject(contextMenu, {"text" : name})
						contextMenu.addAction(action)
					}
				})

				contextMenu.popupEx()
			}

			rowDelegate: ViewDetails.DraggableRowDelegate {
				view: treeView
				reorderEnabled: true
				height: 22
			}

			itemDelegate: Item {
				implicitWidth: row.implicitWidth

				MouseArea {
					Accessible.ignored: true
					width: parent.width
					height: parent.height
					acceptedButtons: Qt.RightButton
					propagateComposedEvents: true
					onClicked: {
						if (!treeView.selection.isSelected(styleData.index)) {
							// Force selection of the item before invoking the menu.
							treeView.selection.select(styleData.index, ItemSelectionModel.ClearAndSelect)
						}
						treeView.showItemMenu(styleData.index)
						mouse.accepted = true
					}
				}

				RowLayout {
					id: row
					anchors.fill: parent

					Controls.CheckBox {
						id: checkBox
						padding: 4
						enabled: model && !model.forceDisabled
						visible: model && model.checkable
						checked: model && model.checked
						onClicked: {
							if (treeView.selection.isSelected(styleData.index)) {
								// If checkbox belongs to a selected item, apply operation to all selection.
								treeView.model.setItemsChecked(treeView.selection.selectedRows(), checked)
							}
							else {
								model.checked = checked
							}
						}
					}

					Misc.IconLabel {
						id: iconLabel
						spacing: 4
						label.text: styleData.value
						label.font.bold: model && model.emphasized
						label.color: model && model.active
							? _palette.color1
							: _palette.color3
						icon.source: model && model.decoration ? "image://gui/" + model.decoration : ""

						Layout.fillWidth: true
					}
				}
			}

			Views.TableViewColumn {
				horizontalAlignment: Text.AlignLeft
				title: "Name"
				role: "display"
			}

			// auto expand functionality
			Timer {
				id: autoExpandTimer
				interval: 0
				onTriggered: treeView.expandAll()
			}

			Component.onCompleted: autoExpandTimer.restart()

			Connections {
				target: treeView
				onModelChanged: autoExpandTimer.restart()
			}

			Connections {
				target: treeView.model
				onModelReset: autoExpandTimer.restart()
			}
		}
	}
}
