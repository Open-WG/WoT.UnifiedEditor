import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQml.Models 2.11
import Panels.PropertyGrid.View 1.0 as View
import WGTools.Controls 2.0 as Controls
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.PropertyGrid 1.0

ControlsEx.Panel {
	id: root

	title: "Parameters"
	layoutHint: "left"

	ColumnLayout {
		anchors.fill: parent

		View.PropertyGrid {
			id: propertyGrid

			property var title: "Parameters"

			Layout.fillWidth: true
			Layout.preferredHeight: contentHeight
			Layout.maximumHeight: parent.height - button.height

			model: PropertyGridModel {
				id: pgModel
				source: {
					if (context && context.controller && context.controller.parameters) {
						return context.controller.parameters.pgObject
					}
				}
				changesController: context.changesController
			}

			selection: ItemSelectionModel {
				model: pgModel
			}
		}

		Controls.Button {
			id: button

			text: "Add Parameter"
			icon.source: "image://gui/add"

			Layout.leftMargin: PropertyGridSettings.propertyLeftPadding + propertyGrid.leftMargin
			Layout.rightMargin: PropertyGridSettings.propertyRightPadding + propertyGrid.rightMargin

			Layout.fillWidth: true

			leftPadding: PropertyGridSettings.propertyLeftPadding
			rightPadding: PropertyGridSettings.propertyRightPadding

			onClicked:{
				parameterPopup.open()
				parameterPopup.y = button.height
			}

			Controls.Menu {
				id: parameterPopup
				modal: true

				width: button.width

				Repeater {
					model: {
						if (context && context.controller && context.controller.parameters) {
							context.controller.parameters.popupModel
						}
					}

					Controls.MenuItem {
						height: 20
						text: itemEntryData.label

						onTriggered: {
							context.controller.parameters.popupModel.
								parameterNeedsToBeAdded(itemEntryData.type,
									"New " + itemEntryData.label)
						}
					}

				}
			}
		}

		Item {
			Layout.fillHeight: true
		}
	}

}