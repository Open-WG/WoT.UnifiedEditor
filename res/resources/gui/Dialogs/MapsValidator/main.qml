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
	id: dlg
	
	property var title: "Maps Validator"

	implicitWidth: 800
	implicitHeight: 600
	color: _palette.color8

	Accessible.name: title

	QtControls.SplitView {
		height: footer.y
		width: parent.width
		orientation: Qt.Horizontal

		ListView {
			id: mapsList
			width: 350
			clip: true
			model: context.validatableMaps

			delegate: Controls.CheckDelegate {
				width: parent.width
				text: model.name
				checked: model.checked
				highlighted: ListView.isCurrentItem

				onClicked: {
					mapsList.currentIndex = index
					forceActiveFocus(Qt.MouseFocusReason)
				}

				onCheckedChanged: {
					model.checked = checked
				}
			}

			Controls.ScrollBar.vertical: Controls.ScrollBar {}
		}

		View.PropertyGrid {
			id: propertyGrid

			model: PropertyGridModel {
				id: pgModel
				source: context.validateSettings
			}

			selection: ItemSelectionModel {
				model: pgModel
			}
		}
	}

	Rectangle {
		id: footer
		color: _palette.color7
		implicitHeight: 55
		width: parent.width
		anchors.bottom: parent.bottom

		Rectangle {
			id: separator
			color: _palette.color9
			width: parent.width
			height: 1
		}

		Controls.Button {
			id: selectAll
			text: "Select All"
			implicitWidth: ControlsSettings.width
			anchors.topMargin: 5
			anchors.top: parent.top
			anchors.leftMargin: 5
			anchors.left: parent.left
			
			onClicked: context.selectAll(true)
		}

		Controls.Button {
			id: deselectAll
			text: "Deselect All"
			implicitWidth: ControlsSettings.width
			anchors.topMargin: 5
			anchors.top: parent.top
			anchors.leftMargin: 5
			anchors.left: selectAll.right
			
			onClicked: context.selectAll(false)
		}

		Controls.Button {
			id: validate
			text: "Validate!"
			implicitWidth: ControlsSettings.width * 2 + 5
			anchors.topMargin: 5
			anchors.top: selectAll.bottom
			anchors.leftMargin: 5
			anchors.left: parent.left
			
			onClicked: context.validate()
		}

		Controls.Button {
			id: close
			text: "Close"
			anchors.margins: 5
			anchors.bottom: parent.bottom
			anchors.right: parent.right
			
			onClicked: context.close()
		}
	}
}
