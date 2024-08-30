import QtQuick 2.11
import "../../Panels/AtlasEditor"
import WGTools.AtlasEditor 1.0
import QtQml.Models 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import WGTools.Controls 2.0 as Controls
import "Details" as Details

Rectangle {
	id: root

	property var title: "Lock Space Mode"

	implicitWidth: 1350
	implicitHeight: 800
	color: _palette.color8

	Accessible.name: title

	QtAtlasModel {
		id: dataModel
		source: context.object
		selection: context.selectionModel
	}

	RowLayout {
		spacing: 5
		anchors.fill: parent

		Atlas {
			id: atlas
			Layout.preferredWidth: height
			Layout.fillHeight: true

			model: context.atlasModel
			viewSettings: context.settings
			selection: context.atlasSelection
			showNumbers: context.showNumbers
			showEmptySlotIcons: true
			showGrid: context.showGrid
			allowAtlasDrag: false
			
			atlasWidth: dataModel.atlasWidth
			atlasHeight: dataModel.atlasHeight
			rowCount: dataModel.rowCount
			columnCount: dataModel.columnCount

			atlasDelegate: Details.AtlasDelegate {
				acceptedButtons: Qt.MiddleButton | Qt.LeftButton

				onClicked: {
					if (mouse.button == Qt.MiddleButton) {
						var pos = mapToItem(atlas, mouseX, mouseY)
						context.zoomTo(pos.x / atlas.width, pos.y / atlas.height)
					}
				}
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

				onClicked: context.filesystemController.updateAtlas()
			}
		}

		ColumnLayout {
			id: controlLayout
			spacing: 0

			Layout.fillWidth: true
			Layout.fillHeight: true

			FileSystemView {
				id: view
				
				Layout.fillWidth: true
				Layout.fillHeight: true

				filesystemSelection: context.fileSystemSelection
			}


			Rectangle {
				Layout.fillWidth: true
				Layout.preferredHeight: 1

				color: _palette.color8
			}

			LockToolButtons {
				Layout.preferredHeight: 47
				Layout.fillWidth: true
				Layout.alignment: Qt.AlignRight
				Layout.rightMargin: 10
				enabled: context.filesystemController.isOnline
			}
		}
	}
}
