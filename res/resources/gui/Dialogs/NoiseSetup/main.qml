import QtQuick 2.11
import QtQml.Models 2.11
import Panels.PropertyGrid.View 1.0 as View
import WGTools.PropertyGrid 1.0
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0 as Details
import WGTools.DialogsQml 1.0 as Dialogs

Rectangle {
	property var title: "Noise Setup"

	implicitWidth: 800
	implicitHeight: 650
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
			spacing: 5
			padding: spacing

			anchors.right: parent.right

			Controls.Button {
				implicitWidth: ControlsSettings.width
				text: "OK"
				onClicked: context.applySettings()
			}
		
			Controls.Button {
				implicitWidth: ControlsSettings.width
				text: "Cancel"
				onClicked: context.cancel()
			}
		}
	}
}
