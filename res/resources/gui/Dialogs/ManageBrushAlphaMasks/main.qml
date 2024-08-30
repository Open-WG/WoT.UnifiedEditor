import QtQuick 2.11
import QtQml.Models 2.11
import Panels.PropertyGrid.View 1.0 as View
import WGTools.PropertyGrid 1.0
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0 as Details
import WGTools.DialogsQml 1.0 as Dialogs

Rectangle {
	property var title: "Manage atlas"

	implicitWidth: 600
	implicitHeight: 500
	color: _palette.color8
	
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
		height: 45

		anchors.bottom: parent.bottom

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
			text: "Add new mask"
			implicitWidth: ControlsSettings.width
			anchors.verticalCenter: parent.verticalCenter
			anchors.leftMargin: 5
			anchors.left: parent.left
			
			onClicked: context.addNewMask()
		}

		Controls.Button {
			id: cancel
			text: "Cancel"
			implicitWidth: ControlsSettings.width
			anchors.verticalCenter: parent.verticalCenter
			anchors.rightMargin: 5
			anchors.right: parent.right
			
			onClicked: context.cancel()
		}

		Controls.Button {
			id: cloneModel
			text: "OK"
			implicitWidth: ControlsSettings.width
			anchors.verticalCenter: parent.verticalCenter
			anchors.rightMargin: 5
			anchors.right: cancel.left
			
			onClicked: context.applyChanges()
		}
	}
}
