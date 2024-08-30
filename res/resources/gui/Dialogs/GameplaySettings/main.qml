import QtQuick 2.11
import QtQml.Models 2.11
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import Panels.PropertyGrid.View 1.0 as View
import WGTools.AtlasEditor 1.0
import WGTools.Debug 1.0
import WGTools.PropertyGrid 1.0
import WGTools.Controls 2.0 as Controls
import "../../Panels/AtlasEditor"

Rectangle {
	id: root

	property var title: "Gameplay Settings"

	property int maximumHeight: propGrid.width < 400 ? height : -1
	property int minimumWidth: propGrid.width < 400 ? width : 900
	property int minimumHeight: 600
	
	implicitWidth: 1350
	implicitHeight: 800
	color: _palette.color8
	focus: true

	Accessible.name: title

	QtAtlasModel {
		id: dataModel
		source: context.object
	}

	ColumnLayout {
		id: mainLayout

		spacing: 5
		anchors.fill: parent

		RowLayout {
			Layout.fillWidth: true

			Atlas {
				id: atlas

				Layout.fillHeight: true
				Layout.preferredWidth: height

				model: dataModel
				viewSettings: context.settings
				selection: null
				showNumbers: context.showNumbers
				rowColumnNumbers: true
				showGrid: context.showGrid
				allowAtlasDrag: false
				atlasWidth: dataModel.atlasWidth
				atlasHeight: dataModel.atlasHeight
				rowCount: dataModel.rowCount
				columnCount: dataModel.columnCount

				Borderline {
					id: borderline

					anchors.fill: parent

					viewport: atlas
					gameplaySettings: context.gameplaySettingsObject
				}

				MapItems {
					anchors.fill: parent

					settings: context.mapItemsSettings
					changesController: context.changesController
				}

				Controls.Button {
					icon.source: "image://gui/icon-refresh"
					hoverEnabled: true
					opacity: hovered ? 0.7 : 0.5
					anchors {
						right: parent.right
						bottom: parent.bottom
						margins: 15
					}

					onClicked: context.reloadAtlas()
				}
			}
			
			View.PropertyGrid {
				id: propGrid

				Layout.fillWidth: true
				Layout.fillHeight: true
				
				model: PropertyGridModel {
					id: pgModel
					source: context.gameplaySettingsObject
					changesController: context.changesController
				}

				selection: ItemSelectionModel {
					model: pgModel
				}
			}
		}

		ToolBar {
			id: toolBar
			Layout.preferredHeight: 21
			Layout.fillWidth: true
			Layout.margins: 10
		}
	}
}
