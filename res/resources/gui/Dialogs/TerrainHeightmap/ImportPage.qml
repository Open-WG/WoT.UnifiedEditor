import QtQuick 2.11
import QtQml.Models 2.11
import Panels.PropertyGrid.View 1.0 as View
import WGTools.PropertyGrid 1.0
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0 as Details

Rectangle {
	property var title: "Import Heightmap - " + context.title

	implicitWidth: 420
	implicitHeight: 160
	color: _palette.color7
	
	View.PropertyGrid {
		width: parent.width
		height: footer.y

		model: PropertyGridModel {
			id: pgModel
			source: context.importOptions
		}
		
		selection: ItemSelectionModel {
			model: pgModel
		}
	}

	Item {
		id: footer
		width: parent.width
		height: buttons.height

		anchors.bottom: parent.bottom

		Rectangle { // separator
			width: parent.width; height: 1
			color: _palette.color9
		}
		
		Row {
			id: buttons
			spacing: 5
			padding: spacing

			anchors.right: parent.right
		
			Controls.Button {
				implicitWidth: ControlsSettings.width
				text: "Import"
				onClicked: context.importHeightmap()
			}

			Controls.Button {
				implicitWidth: ControlsSettings.width
				text: "Cancel"
				onClicked: context.cancel()
			}
		}
	}
}
