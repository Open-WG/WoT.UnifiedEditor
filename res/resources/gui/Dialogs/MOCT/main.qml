import QtQml.Models 2.11
import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import WGTools.Controls 2.0 as Controls
import WGTools.Misc 1.0 as Misc
import WGTools.Debug 1.0 as Debug
import Panels.PropertyGrid.View 1.0 as View
import WGTools.PropertyGrid 1.0

Rectangle {
	property var title: "Map Objects Copying for Testing"

	implicitWidth: 800
	implicitHeight: 600
	color: _palette.color7

	Accessible.name: title

	PropertyGridModel {
		id: pgModel
		source: context.object
	}

	ItemSelectionModel {
		id: pgSelection
		model: pgModel
	}
	
	SplitView {
		anchors.fill: parent
		orientation: Qt.Horizontal

		ColumnLayout {
			Layout.fillHeight: true

			ListView {
				id: mapsList
				implicitWidth: 350
				clip: true
				model: context.mapsList
				
				delegate: Controls.CheckDelegate {
					width: parent.width
					text: model.name
					checked: model.checked
					highlighted: ListView.isCurrentItem

					onClicked: {
						mapsList.currentIndex = index
						forceActiveFocus()
					}

					onToggled: {
						model.checked = checked
						context.validate();
					}
				}

				Controls.ScrollBar.vertical: Controls.ScrollBar {}

				Layout.fillWidth: true
				Layout.fillHeight: true
			}

			Rectangle {
				clip: true
				color: _palette.color7
				width: mapsList.width
				implicitHeight: column.implicitHeight

				Column {
					id: column
					spacing: 5
					padding: column.spacing
					anchors.centerIn: parent

					Row {
						id: row
						spacing: column.spacing

						Controls.Button {
							id: selectAll
							text: "Select all"
							implicitWidth: 70
							onClicked: context.selectAll(true)
						}

						Controls.Button {
							id: deselectAll
							text: "Deselect all"
							implicitWidth: 70
							onClicked: context.selectAll(false)
						}
					}

					Controls.Button {
						id: run
						text: "Run"
						enabled: context.runEnabled
						implicitWidth: 140 + row.spacing
					
						onClicked: context.run()
					}
				}
			}
		}

		View.PropertyGrid {
			id: propertyGrid
			model: pgModel
			selection: pgSelection

			Layout.fillWidth: true
			Layout.fillHeight: true
		}
	}
}
