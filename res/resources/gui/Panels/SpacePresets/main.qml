import QtQuick 2.11
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0 as Controls
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Views 1.0 as Views
import WGTools.Views.Styles 1.0 as ViewStyles
import WGTools.Styles.Text 1.0 as StyledText
import WGTools.Clickomatic 1.0 as Clickomatic

ControlsEx.Panel {
	id: spacePresets
	
	title: "Presets"
	layoutHint: "bottom"
	property var margins: 10

	RowLayout {
		id: buttonsLayout
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: parent.margins
		
		Label {
			text: "Environment Preset:"
			color: _palette.color2
		}
		
		Controls.ComboBox {
			Accessible.name: "Environment Preset"
			model: context.presetsListModel
			currentIndex: context.currentIndex
			
			Layout.fillWidth: true
			textRole: "presetName"
			onActivated: context.currentIndex = currentIndex
		}

		Controls.Button {
		
			id: reloadBtn
			text: "Reload"
			
			implicitWidth: 64
			
			onPressed: {
				context.reloadPresets()
			}
		}
		
		Item {
			// spacer item
			Layout.fillWidth: true
			Layout.fillHeight: true
			Rectangle { anchors.fill: parent; color: _palette.color8 } 
		}
	}
	
	RowLayout {
		id: checksLayout
		anchors.top: buttonsLayout.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: parent.margins
		
		Controls.CheckBox {
			id: checkAll
			Accessible.name: "Check All"
			
			checked: context.optionChecked

			onClicked: {
				context.onAllOptionsChecked(checkAll.checked)
			}
		}
		
		Controls.ComboBox {
			id: checksCombo
			Accessible.name: "Check By"
			editable: true

			model: context.optionsGroupModel
			textRole: "cheksName"
			
			implicitWidth: 128
			
			onActivated: {
				context.acceptGroup(index)	
			}
		}

		Controls.Button {
			id: storeBtn
			Accessible.name: "Add"
			icon.source: "../../../images/add-component.svg"
			
			onPressed: {
				context.storeGroup(checksCombo.editText)
				checksCombo.currentIndex = checksCombo.count-1
			}
		}
		
		Controls.Button {
			id: deleteBtn
			Accessible.name: "Delete"
			
			icon.source: "../../../images/delete.svg"
			
			onPressed: {
				context.deleteGroup(checksCombo.currentIndex)
				checksCombo.currentIndex = 0
			}
		}
		
		Item {
			// spacer item
			Layout.fillWidth: true
			Layout.fillHeight: true
			Rectangle { anchors.fill: parent; color: _palette.color8 } 
		}
	}
	
	Views.TreeView {
		id: parametersTree
		model: context.model     
		accesibleNameRole: nameColumn.role
		
		anchors.top: checksLayout.bottom
		anchors.bottom: applyLayout.top
		anchors.margins: parent.margins
		width: parent.width

		headerVisible: true
		
		alternatingRowColors: false
		
		style: ViewStyles.TreeViewStyle{
			backgroundColor: _palette.color8
		}
		
		TableViewColumn {
			id: nameColumn
			title: "Parameter"
			role: "display"
			
			delegate: RowLayout {
				id: tableRow
				Accessible.name: accesibleNameGenerator.value
				Clickomatic.TableAccesibleNameGenerator {
					id: accesibleNameGenerator
					role: parametersTree.accesibleNameRole
					modelIndex: styleData.index
				}

				Controls.CheckBox {
					id: checkProperty
					Accessible.name: "Checkbox"
					
					checked: model && model.checked
		
					onClicked: {
						model.checked = checkProperty.checked
					}
				}
				
				StyledText.BaseRegular {
					id: titleText
					elide: Text.ElideRight
					Layout.fillWidth: true
					
					text: styleData.value
				}
			}
		}

		Component {
			id: parameterPreset
			StyledText.BaseRegular {
				anchors.verticalCenter: parent.verticalCenter
				text: styleData.value ? styleData.value : ""
				color: (model && model.equal)
					? _palette.color3
					: _palette.color2
				elide: Text.ElideRight
			}
		}
		
		TableViewColumn {
			title: "Old (Space)"
			role: "spaceParameter"
			
			delegate: parameterPreset
		}
		
		TableViewColumn {
			title: "New (Preset)"
			role: "presetParameter"
			
			delegate: parameterPreset
		}
	}

	RowLayout {
		id: applyLayout
		
		implicitHeight: 40

		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.margins: parent.margins
		
		Controls.Button {
		
			id: loadButton
			
			Layout.fillWidth: true
			text: "Apply"
			enabled: context.applyEnabled
			
			onPressed: {
				context.loadPreset()
			}
		}

	}
}