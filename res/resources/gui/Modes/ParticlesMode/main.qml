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
		spacing: 7
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
				treeView.model.pasteIntoItems(treeView.selection.selectedRows())
			}
		}

		Shortcut {
			sequence: StandardKey.Delete
			onActivated: {
				treeView.model.removeItems(treeView.selection.selectedRows())
			}
		}

		Rectangle {
			Layout.fillWidth: true
			height: 1
			color: "gray"
		}
		
		Controls.Button {
			Layout.leftMargin: 4
			text: "Add Influx Group"
			onClicked: {
				treeView.model.addInfluxGroup()
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

				readonly property var _lodCountColor: _palette.color2
				readonly property var _emitterLifetimeColor: "#04b25b"
				readonly property var _particlesLifetimeColor: "#00b6fe"
				readonly property var _particleCountColor: "#ffae00"

				property bool _modelActive: model && model.active
				property bool _showEmitterLifetime: model && typeof model.emitterLifetime !== 'undefined'
				property bool _showLodDistance: model && typeof model.lodDistance !== 'undefined'
				property bool _showParticleCount: model && typeof model.particleCount !== 'undefined'
				property bool _showParticleLifetime: model && typeof model.particleLifetime !== 'undefined'

				function formatToolTip(model) {
					if (model === null) return "";
					function formatRow(label, value, color) {
						return "<font color=\"" + _palette.color1 + "\">" + label + ": </font> " +
							   "<font color=\"" + color + "\">" + value + "</font>"
					}
					let rows = []
					if (typeof model.emitterLifetime !== 'undefined') {
						rows.push(formatRow("Emitter Lifetime", model.emitterLifetime, _emitterLifetimeColor))
					}
					if (typeof model.lodDistance !== 'undefined') {
						rows.push(formatRow("LOD Distance", model.lodDistance, _lodCountColor))
					}
					if (typeof model.particleCount !== 'undefined') {
						rows.push(formatRow("Particle Count", model.particleCount, _particleCountColor))
					}
					if (typeof model.particleLifetime !== 'undefined') {
						rows.push(formatRow("Particles Lifetime", model.particleLifetime, _particlesLifetimeColor))
					}
					return rows.join(" <br/> ")
				}

				MouseArea {
					id: itemMouseArea
					Accessible.ignored: true
					width: parent.width
					height: parent.height
					acceptedButtons: Qt.RightButton
					propagateComposedEvents: true
					hoverEnabled: true
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

					anchors.bottom: parent.bottom
					anchors.top: parent.top
					
					spacing: 2

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

					Image {
						fillMode: Image.PreserveAspectFit
						sourceSize.width: width
						sourceSize.height: height
						source: model && model.decoration ? "image://gui/" + model.decoration : ""
					}

					Misc.Text {
						visible: _showEmitterLifetime
						text: _showEmitterLifetime ? model.emitterLifetime : ""
						color: _modelActive ? _emitterLifetimeColor : _palette.color3
					}

					Misc.Text {
						visible: _showEmitterLifetime
						text: "|"
						color: _palette.color3
					}

					Misc.Text {
						visible: _showLodDistance
						text: _showLodDistance ? model.lodDistance : ""
						color: _modelActive ? _lodCountColor : _palette.color3
					}

					Misc.Text {
						visible: _showLodDistance
						text: "|"
						color: _palette.color3
					}

					Misc.Text {
						visible: _showParticleCount
						text: _showParticleCount ? model.particleCount : ""
						color: _modelActive ? _particleCountColor : _palette.color3
					}

					Misc.Text {
						visible: _showParticleCount
						text: "|"
						color: _palette.color3
					}

					Misc.Text {
						visible: _showParticleLifetime
						text: _showParticleLifetime ? model.particleLifetime : ""
						color: _modelActive ? _particlesLifetimeColor : _palette.color3
					}

					Misc.Text {
						visible: _showParticleLifetime
						text: "|"
						color: _palette.color3
					}

					Misc.Text {
						text: styleData.value
						font.bold: model && model.emphasized
						color: _modelActive ? _palette.color1 : _palette.color3
					}

					Item {
						Layout.fillWidth: true
					}

					Controls.Button {
						id: minusButton
						icon.source: "image://gui/icon-remove"
						visible: model && model.removable
						onClicked: {
							treeView.model.removeInfluxGroup(styleData.index)
						}
					}
				}

				Controls.ToolTip {
					visible: itemMouseArea.containsMouse && text !== ""
					delay: 500
					text: formatToolTip(model)
					background: Rectangle {
						color: _palette.color5
					}
				}

				Timer {
					id: expandTimer
					interval: 0
					onTriggered: {
						if (model && model.expanded) {
							treeView.expand(styleData.index)
						}
					}
				}

				Component.onCompleted: {
					expandTimer.start()
				}

				Connections {
					target: styleData
					ignoreUnknownSignals: true

					onIsExpandedChanged: {
						if (model) {
							model.expanded = styleData.isExpanded
						}
					}

					onValueChanged: {
						expandTimer.start()
					}
				}
			}

			Views.TableViewColumn {
				horizontalAlignment: Text.AlignLeft
				title: "Name"
				role: "display"
			}
		}
	}
}
