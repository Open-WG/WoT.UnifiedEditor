import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4 as QtControls
import QtQml.Models 2.11
import QtQuick.Controls 2.3 as QtControls
import Panels.PropertyGrid.View 1.0 as View
import WGTools.PropertyGrid 1.0
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0 as Details
import WGTools.DialogsQml 1.0 as Dialogs
import WGTools.Views.Details 1.0 as Views

Rectangle {
	id: root

	property var title: "AI Game Mode"

	implicitWidth: 160
	implicitHeight: 450
	color: _palette.color7
	focus: true

	Accessible.name: title

	View.PropertyGrid {
		id: propertyGrid

		model: PropertyGridModel {
			id: pgModel
			source: context.gameModes
		
		}

		selection: ItemSelectionModel {
			model: pgModel
		}
	}

	Controls.Button {
		id: applay
		text: "Apply"
		anchors.margins: 5
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		onClicked: context.applay()
	}

	Controls.Button {
		id: close
		text: "Close"
		anchors.margins: 5
		anchors.right: parent.right
		anchors.bottom: parent.bottom	
		onClicked: context.close()
	}
}
