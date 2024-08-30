import QtQuick 2.11
import QtQml.Models 2.11
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0 as Details
import WGTools.PropertyGrid 1.0
import Panels.PropertyGrid.View 1.0 as View

Rectangle {
	color: _palette.color8

	Accessible.name: qmlView.title
	property int minimumHeight : propertyGridView.implicitHeight + footer.height

	View.PropertyGrid {
		id: propertyGridView
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
		height: context.showDialogButtons ? buttons.height : 0
		visible: context.showDialogButtons

		anchors.bottom: parent.bottom

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
				text: "Ok"
				enabled: !context.hasOwnProperty("acceptable") || context.acceptable
				onClicked: context.accept()
			}

			Controls.Button {
				implicitWidth: ControlsSettings.width
				text: "Cancel"
				onClicked: context.reject()
			}
		}
	}
}
