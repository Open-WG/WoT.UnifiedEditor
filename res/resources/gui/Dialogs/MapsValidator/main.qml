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
	property var title: "Maps Validator"

	implicitWidth: 800
	implicitHeight: 600
	color: _palette.color8

	Accessible.name: title

	QtControls.SplitView {
		height: footer.y
		width: parent.width
		orientation: Qt.Horizontal

		Item {
			width: 350

			Rectangle {
				id: mapListButtons
				color: _palette.color7
				implicitHeight: 30
				anchors {
					top: parent.top
					left: parent.left
					right: parent.right
				}

				Controls.Button {
					id: selectAllMaps
					text: "Select All"
					implicitWidth: ControlsSettings.width
					anchors.topMargin: 5
					anchors.top: parent.top
					anchors.leftMargin: 5
					anchors.left: parent.left
					
					onClicked: context.selectAllMaps(true)
				}

				Controls.Button {
					id: deselectAllMaps
					text: "Deselect All"
					implicitWidth: ControlsSettings.width
					anchors.topMargin: 5
					anchors.top: parent.top
					anchors.leftMargin: 5
					anchors.left: selectAllMaps.right
					
					onClicked: context.selectAllMaps(false)
				}
			}

			ListView {
				id: mapsList
				anchors {
					top: mapListButtons.bottom
					left: parent.left
					right: parent.right
					bottom: parent.bottom
				}
				width: 350
				clip: true
				model: context.mapListModel

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
		}

		QtControls.SplitView {
			orientation: Qt.Vertical

			Item {
				height: 350

				Rectangle {
					id: scenarioListButtons
					color: _palette.color7
					implicitHeight: 30
					anchors {
						top: parent.top
						left: parent.left
						right: parent.right
					}

					Controls.Button {
						id: selectAllScenarios
						text: "Select All"
						implicitWidth: ControlsSettings.width
						anchors.topMargin: 5
						anchors.top: parent.top
						anchors.leftMargin: 5
						anchors.left: parent.left
						
						onClicked: context.selectAllScenarios(true)
					}

					Controls.Button {
						id: deselectAllScenarios
						text: "Deselect All"
						implicitWidth: ControlsSettings.width
						anchors.topMargin: 5
						anchors.top: parent.top
						anchors.leftMargin: 5
						anchors.left: selectAllScenarios.right
						
						onClicked: context.selectAllScenarios(false)
					}
				}

				ListView {
					id: scenarioList
					clip: true
					model: context.scenarioListModel
					anchors {
						top: scenarioListButtons.bottom
						left: parent.left
						right: parent.right
						bottom: parent.bottom
					}

					delegate: Controls.CheckDelegate {
						width: parent.width
						text: model.name
						checked: model.checked
						highlighted: ListView.isCurrentItem

						onClicked: {
							scenarioList.currentIndex = index
							forceActiveFocus(Qt.MouseFocusReason)
						}

						onCheckedChanged: {
							model.checked = checked
						}
					}

					Controls.ScrollBar.vertical: Controls.ScrollBar {}
				}
			}

			View.PropertyGrid {
				id: propertyGrid

				model: PropertyGridModel {
					id: validationSettings
					source: context.validationSettings
				}

				selection: ItemSelectionModel {
					model: validationSettings
				}
			}
		}
	}

	Rectangle {
		id: footer
		color: _palette.color7
		implicitHeight: 30
		width: parent.width
		anchors.bottom: parent.bottom

		Controls.Button {
			id: validate
			text: "Validate!"
			implicitWidth: ControlsSettings.width * 2 + 5
			anchors.margins: 5
			anchors.bottom: parent.bottom
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
