import QtQuick 2.11
import QtQml.Models 2.11
import Panels.PropertyGrid.View 1.0 as View
import WGTools.PropertyGrid 1.0
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0 as Details
import WGTools.DialogsQml 1.0 as Dialogs

Rectangle {
	property var title: "Create Atlas"

	implicitWidth: 420
	implicitHeight: 160
	color: _palette.color8
	
	Accessible.name: title
	
	View.PropertyGrid {
		width: parent.width
		height: footer.y

		model: PropertyGridModel {
			id: pgModel
			source: context.object
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

			readonly property real buttonsImplicitWidth: 70
			spacing: 5
			padding: spacing

			anchors.right: parent.right

			Controls.Button {
				implicitWidth: ControlsSettings.width
				text: "Create"
				onClicked: dialog.window.open()

				Dialogs.FileDialog {
					id: dialog
					initialFolder: "content/"
					anyDir: false

					window.title: "Create new atlas"
					window.saveMode: true
					window.selectExisting: false
					window.nameFilters: [context.filter]

					onPathAccepted: context.createAtlas(filePath)
				}
			}

			Controls.Button {
				implicitWidth: ControlsSettings.width
				text: "Cancel"
				onClicked: context.cancel()
			}
		}
	}
}
