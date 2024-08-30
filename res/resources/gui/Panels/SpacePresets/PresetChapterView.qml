import QtQuick 2.11
import QtQuick.Controls 1.4 as QuickControls1
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0 as Controls
import WGTools.Views 1.0 as Views
import WGTools.Views.Styles 1.0 as ViewStyles
import WGTools.Styles.Text 1.0 as StyledText

Item {
	id: view
	property var viewContext: null
	property var orientation: Qt.Horizontal
	property var buttonWidth: 128
	property var controlsMargin: 5

	Controls.Menu {
		id: contextMenu

		property var presetIndex
		property var presetName

		Controls.MenuItem {
			text: "Apply Preset"
			onTriggered: viewContext.applyPreset(contextMenu.presetIndex)
		}
		Controls.MenuItem {
			text: "Copy Preset to Clipboard"
			onTriggered: viewContext.copyPresetToClipboard(contextMenu.presetIndex)
		}
		Controls.MenuSeparator {}
		Controls.MenuItem {
			text: "Show Presets File"
			onTriggered: viewContext.showStorageFile()
		}
		Controls.MenuSeparator {}
		Controls.MenuItem {
			text: "Delete Preset"
			onTriggered: viewContext.showDeletePresetDialog(contextMenu.presetIndex)
		}
	}

	QuickControls1.SplitView {
		id: splitView

		orientation: view.orientation
		handleDelegate: Rectangle { width: 1; color: _palette.color7 }

		anchors.fill: parent

		ColumnLayout {
			implicitWidth: splitView.width * 0.25
			implicitHeight: implicitWidth

			RowLayout {
				id: presetControls
				spacing: 5

				Controls.Button {
					implicitWidth: buttonWidth
					text: "Reload Presets"
					icon.source: "image://gui/model_asset/refresh"
					onClicked: viewContext.reloadPresets()
				}

				Controls.Button {
					implicitWidth: buttonWidth
					text: "Add Preset"
					visible: viewContext.presetsEditable
					icon.source: "image://gui/model_asset/add"
					onClicked: viewContext.showNewPresetDialog()
				}
			}

			Views.TableView {
				id: presetList
				Layout.fillWidth: true
				Layout.fillHeight: true
				Layout.topMargin: controlsMargin

				model: viewContext.presetListModel
				headerVisible: false
				selectionMode: QuickControls1.SelectionMode.SingleSelection

				QuickControls1.TableViewColumn {
					title: "Parameter"
					role: "presetName"
					
					delegate: Item {
						id: presetDelegate
						StyledText.BaseRegular {
							anchors.left: parent.left
							anchors.leftMargin: 5
							anchors.verticalCenter: parent.verticalCenter
							elide: Text.ElideRight
							text: styleData.value
						}
						Item {
							id: deleteButton
							width: parent.height
							anchors.right: parent.right
							anchors.top: parent.top
							anchors.bottom: parent.bottom
							anchors.rightMargin: 5
							visible: viewContext.presetsEditable && model && !model.presetIsRuntime && presetMouseArea.containsMouse
							Image {
								width: 16
								height: 16
								anchors.horizontalCenter: parent.horizontalCenter
								anchors.verticalCenter: parent.verticalCenter
								source: "image://gui/model_asset/delete"
							}
							MouseArea {
								anchors.fill: parent
								acceptedButtons: Qt.LeftButton
								onClicked: viewContext.showDeletePresetDialog(styleData.row)
							}
						}
						Rectangle {
							anchors.fill: parent
							color: "transparent"
							border.color: _palette.color12
							border.width: 2
							visible: !styleData.selected && presetMouseArea.containsMouse
						}
						MouseArea {
							id: presetMouseArea
							anchors.fill: parent
							acceptedButtons: Qt.RightButton
							hoverEnabled: true
							onClicked: {
								if (model && !model.presetIsRuntime) {
									contextMenu.presetIndex = styleData.row
									contextMenu.presetName = styleData.value
									contextMenu.popupEx()
								}
							}
						}
					}
				}

				Connections {
					target: presetList.selection
					Component.onCompleted: {
						presetList.selection.select(viewContext.currentPreset)
					}
					onSelectionChanged: {
						presetList.selection.forEach(function(index) {
							if (viewContext.currentPreset !== index) {
								viewContext.currentPreset = index
							}
						})
					}
				}

				Connections {
					target: viewContext
					onCurrentPresetChanged: {
						presetList.selection.clear()
						presetList.selection.select(viewContext.currentPreset)
					}
				}
			}
		}

		ColumnLayout {
			RowLayout {
				id: optionControls
				Layout.leftMargin: 16
				spacing: 5

				Controls.CheckBox {
					id: selectAll
					text: "All"
					checked: viewContext.allOptionsSelected
					onClicked: viewContext.selectAllOptions(selectAll.checked)
				}

				Controls.Button {
					implicitWidth: buttonWidth
					enabled: viewContext.applyEnabled
					text: "Apply Preset"
					onClicked: {
						viewContext.applyPreset(viewContext.currentPreset)
					}
				}

				Controls.Button {
					implicitWidth: buttonWidth * 1.5
					visible: viewContext.presetsEditable
					enabled: viewContext.saveEnabled
					text: "Save Selected Options"
					icon.source: "image://gui/toolbar-save"
					onClicked: viewContext.savePreset(viewContext.currentPreset)
				}
			}

			Views.TreeView {
				id: optionTree
				Layout.topMargin: controlsMargin
				Layout.fillWidth: true
				Layout.fillHeight: true

				model: viewContext.optionTreeModel
				headerVisible: true
				alternatingRowColors: false
				
				style: ViewStyles.TreeViewStyle{
					backgroundColor: _palette.color8
				}
				
				QuickControls1.TableViewColumn {
					id: nameColumn
					title: "Parameter"
					role: "display"
					
					delegate: RowLayout {
						id: tableRow

						Controls.CheckBox {
							id: checkProperty
							checked: model && model.selected
							onClicked: model.selected = checkProperty.checked
						}
						
						StyledText.BaseRegular {
							id: titleText
							Layout.fillWidth: true
							Layout.alignment: Qt.AlignVCenter
							font.bold: (model && model.branchHasDiff)
							elide: Text.ElideRight
							text: styleData.value
						}
					}
				}

				Component {
					id: optionValue
					StyledText.BaseRegular {
						Layout.alignment: Qt.AlignVCenter
						color: (model && model.branchHasDiff) ? _palette.color2 : _palette.color3
						elide: Text.ElideRight
						text: styleData.value ? styleData.value : ""
					}
				}
				
				QuickControls1.TableViewColumn {
					title: "Old (Space)"
					role: "sourceData"
					delegate: optionValue
				}
				
				QuickControls1.TableViewColumn {
					title: "New (Preset)"
					role: "presetData"
					delegate: optionValue
				}
			}
		}
	}
}
