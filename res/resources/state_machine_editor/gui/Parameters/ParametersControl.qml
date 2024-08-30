import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

import QtQml.Models 2.2

import Controls 1.0 as SMEControls
import ParameterType 1.0

import "..//Dialogs"

Rectangle {
	id: root

	color: "#4a4a4a"

	property var controller: null

	MouseArea {
		anchors.fill: parent
		onClicked: {
			forceActiveFocus()
		}
	}
	
	ColumnLayout {
		spacing: 0
		width: parent.width

		Rectangle {
			color: "#333333"
			height: 26
			Layout.fillWidth: true
			Layout.fillHeight: true

			SMEControls.Text {
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 15

				width: parent.width - anchors.leftMargin - anchors.rightMargin

				text: "Parameters"
				elide: Text.ElideRight
				color: "white"

				font.family: "Proxima Nova Th"
				font.pixelSize: 13
			}
		}

		RowLayout {
			Layout.topMargin: 10
			Layout.bottomMargin: 10
			Layout.leftMargin: 10
			Layout.rightMargin: 10
			Layout.fillWidth: true

			ColumnLayout {
				Layout.fillWidth: true
				
				Repeater {
					model: DelegateModel {
						model: controller.stateMachineParameters

						delegate: SMEControls.TextField {
							Layout.preferredHeight: 20
							Layout.fillWidth: true
							Layout.alignment: Qt.AlignVCenter

							Binding on text {
								value: itemParameterData.name
							}

							hoverEnabled:true
							selectByMouse: true
							padding: 0

							onEditingFinished: {
								if (text == itemParameterData.name)
									return

								var name = controller.stateMachineParameters.
									fixParameterName(text)
								itemParameterData.name = name
								text = name
							}
						}
					}
				}
			}

			ColumnLayout {
				Layout.fillWidth: true
				
				Repeater {
					model: DelegateModel {
						id: valueDelModel

						model: controller.stateMachineParameters

						delegate: RowLayout {
							id: parameterLayout

							Layout.preferredHeight: 20

							function deleteParameter() {
								controller.stateMachineParameters.removeParameter(
									valueDelModel.modelIndex(index))
							}

							SMEControls.Button {
								Layout.preferredHeight: 20

								text: "x"

								onClicked: {
									if (controller.stateMachineParameters.canRemove(
											valueDelModel.modelIndex(index)))
										parameterLayout.deleteParameter()
									else
										parameterDeletionDialog.open()
								}

								ParameterDeletionDialog {
									id: parameterDeletionDialog

									parent: mainWindow

									closePolicy: Popup.NoAutoClose

									x: mainWindow.width / 2 - width / 2
									y: mainWindow.height / 2 - height / 2

									onAccepted: {
										parameterLayout.deleteParameter()
									}
								}
							}
						}
					}
				}
			}
		}

		SMEControls.Button {
			id: addParameterButton

			Layout.topMargin: 10
			Layout.bottomMargin: 10
			Layout.leftMargin: 10
			Layout.rightMargin: 10
			Layout.fillWidth: true

			text: "Add Parameter"

			onClicked: {
				parameterPopup.open()
				parameterPopup.y = addParameterButton.height
			}

			SMEControls.Menu {
				id: parameterPopup
				modal: true

				width: addParameterButton.width

				Repeater {
					model: controller.stateMachineParameters.parametersPopupModel

					SMEControls.MenuItem {
						height: 20
						text: itemEntryData.label

						onTriggered: {
							controller.stateMachineParameters.parametersPopupModel.
								parameterNeedsToBeAdded(itemEntryData.type,
									"New " + itemEntryData.label)
						}
					}

				}
			}
		}
	}
}