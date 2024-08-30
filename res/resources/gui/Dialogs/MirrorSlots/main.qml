import QtQuick 2.11
import QtQml.Models 2.11
import Panels.PropertyGrid.View 1.0 as View
import WGTools.PropertyGrid 1.0
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0 as Details

Rectangle {
	id: root

	property var title: "Mirror"
	
	implicitWidth: 350
	implicitHeight: 150

	color: _palette.color8
	focus: true

	Accessible.name: title

	View.PropertyGrid {
		id: propertyGridView
		width: parent.width
		height: footer.y

		model: PropertyGridModel {
			id: pgModel
			source: context.settings
		}

		selection: ItemSelectionModel {
			model: pgModel
		}
	}

	Item {
		id: footer
		width: parent.width
		anchors.bottom: parent.bottom
		height: buttons.height

		Rectangle { // separator
			height: 1
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.leftMargin: 8
			anchors.rightMargin: 8
			color: _palette.color9
		}

		Row {
			id: buttons
			spacing: 5
			padding: spacing
			anchors.right: parent.right

			Controls.Button {
				implicitWidth: ControlsSettings.width
				text: "Apply"
				enabled: context.appliableState
				onClicked: context.apply()
			}

			Controls.Button {
				implicitWidth: ControlsSettings.width
				text: "Cancel"
				onClicked: context.canceled()
			}
		}
	}
}
