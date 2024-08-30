import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQml.Models 2.11
import Panels.PropertyGrid.View 1.0 as View
import WGTools.PropertyGrid 1.0
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0 as Details
import WGTools.DialogsQml 1.0 as Dialogs
import WGTools.Debug 1.0
import WGTools.Views.Details 1.0 as Views

Rectangle {
	id: dlg

	property var title: "Import Tile Masks"

	color: _palette.color7
	implicitWidth: 750
	implicitHeight: 570

	Accessible.name: title

	Dialogs.FileDialog {
		id: addTileTextureDialog
		anyDir : false
		initialFolder : context.initialFolder
		window.title : "Add Tile Texture"
		window.nameFilters : [ "Tile (*.dds)" ]
		onPathAccepted: context.addTexture(filePath)
	}

	ColumnLayout {
		anchors.fill: parent

		SplitView {
			Layout.fillHeight: true
			Layout.fillWidth: true
			orientation: Qt.Horizontal

			ListView {
				id: tilesList
				width: 350
				clip: true
				model: context.tileMasksList
				delegate: Views.RowDelegate {
					width: parent.width
					height: layout.implicitHeight + layout.anchors.topMargin + layout.anchors.bottomMargin

					readonly property QtObject styleData: QtObject {
						readonly property bool alternate: false
						readonly property bool selected: index == tilesList.currentIndex
						readonly property bool hasActiveFocus: false
						readonly property bool hovered: ma.containsMouse
					}

					MouseArea {
						id: ma
						hoverEnabled: true
						anchors.fill: parent
						onClicked: tilesList.currentIndex = index
					}

					RowLayout {
						id: layout
						anchors.margins: 5
						anchors.fill: parent

						Text {
							text: model.tileName ? model.tileName : ""
							color: _palette.color2
							Layout.fillWidth: true
						}

						Rectangle {
							width: 64
							height: 64
							color: "black"
							Image {
								sourceSize.width:64
								sourceSize.height:64
								source: model.preview ? model.preview : ""
								fillMode: Image.PreserveAspectFit
							}
						}
					}
				}

				Layout.fillHeight: true

				onCurrentIndexChanged: {
					context.selectTextureForEditing(tilesList.currentIndex)
				}
			}
			
			View.PropertyGrid {
				id: propertyGrid

			model: PropertyGridModel {
				id: pgModel
				source: context.currentTile
			}

			selection: ItemSelectionModel {
				model: pgModel
			}

				Layout.fillWidth: true
				Layout.fillHeight: true
			}
		}

		Rectangle {
			id: footer
			color: _palette.color7
			implicitHeight: 45
			Layout.fillWidth: true

			Rectangle {
				id: separator
				color: _palette.color9
				width: parent.width
				height: 1
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.right: parent.right
			}

			Controls.Button {
				id: add
				text: "Add Tile Texture..."
				implicitWidth: 125
				anchors.verticalCenter: parent.verticalCenter
				anchors.leftMargin: 5
				anchors.left: parent.left
				
				onClicked: {
					addTileTextureDialog.window.open()
				}
			}

			Controls.Button {
				id: remove
				text: "Remove Selected Tile"
				implicitWidth: 125
				anchors.verticalCenter: parent.verticalCenter
				anchors.leftMargin: 5
				anchors.left: add.right
				
				onClicked: {
					context.removeTexture(tilesList.currentIndex)
					context.selectTextureForEditing(tilesList.currentIndex)
				}
			}

			Controls.Button {
				id: importFromFile
				text: "Import From File..."
				implicitWidth: 125
				anchors.verticalCenter: parent.verticalCenter
				anchors.rightMargin: 5
				anchors.right: apply.left
				
				onClicked: context.importFromFile()
			}

			Controls.Button {
				id: apply
				text: "Apply"
				implicitWidth: 50
				anchors.verticalCenter: parent.verticalCenter
				anchors.rightMargin: 5
				anchors.right: cancel.left

				enabled: tilesList.count != 0
				
				onClicked: context.apply()
			}

			Controls.Button {
				id: cancel
				text: "Cancel"
				implicitWidth: 50
				anchors.verticalCenter: parent.verticalCenter
				anchors.rightMargin: 5
				anchors.right: parent.right
				
				onClicked: context.cancel()
			}
		}
	}
}
