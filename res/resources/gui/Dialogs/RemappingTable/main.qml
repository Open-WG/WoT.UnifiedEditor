import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.3

import WGTools.Controls 2.0 as Controls
import WGTools.Views 1.0 as Views

Rectangle {
	property var title: "Remapping Table For Gameplay Types"
	Accessible.name: title

	implicitHeight: 500
	implicitWidth: 600

	color: _palette.color7


	ColumnLayout {
		anchors.fill: parent 

		Views.TableView {
			id: tableView

			selectionMode : SelectionMode.NoSelection
			Layout.fillWidth: true
			Layout.fillHeight: true

			model: context

			TableViewColumn {
				id: nameId
				role: "name"
				title: "Name"
				width: 200

				delegate:
					ComboBoxDelegate {
						model: gameplayType ? gameplayType.nameModel : []
						currentIndex: gameplayType ? gameplayType.nameModelIndex : -1

						Connections {
							target: gameplayType
							onNameModelIndexChanged: {
								currentIndex = gameplayType.nameModelIndex
							}
						}
					}
			}

			TableViewColumn {
				id: bitIndexId
				role: "bitIndex"
				title: "Bit Index"
				width: 100

				delegate:
					ComboBoxDelegate {
						model: gameplayType ? gameplayType.bitIndexModel : []
						currentIndex: gameplayType ? gameplayType.bitIndexModelIndex : -1

						Connections {
							target: gameplayType
							onBitIndexModelIndexChanged: {
								currentIndex = gameplayType.bitIndexModelIndex
							}
						}
					}
			}

			TableViewColumn {
				id: actionId
				role: "action"
				title: "Bit Action"
				width: 150

				delegate:
					ComboBoxDelegate {
						id: actionIdDelegate
						model: gameplayType ? gameplayType.actionModel : []
						currentIndex: gameplayType ? gameplayType.actionModelIndex : -1

						Connections {
							target: gameplayType
							onActionModelIndexChanged: {
								currentIndex = gameplayType.actionModelIndex
							}
						}

						Controls.ToolTip {
							delay: 500
							parent: actionIdDelegate
							visible: actionIdDelegate.hovered
							text: "Do Nothing - If bit index is changed then it's value is copied from current to new bit and unused bits are disabled\n" +
								"Disable All - Disable bit value for all items.\nEnable All - Enable bit value for all items."
						}
					}
			}

			TableViewColumn {
				id: removeId
				title: "Remove"
				width: 100

				delegate: Controls.Button {
					text: "Remove"
					onClicked: {
						context.removeGameplayType(styleData.row);
					}
				}
			}
		}

		RowLayout {
			Layout.preferredHeight: 50
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
			Layout.rightMargin: 20
			
			Controls.Button {
				id: addButton
				text: "Add Gameplay Type"
				enabled: context.canAddGameplayType
				onClicked: {
					context.addGameplayType();
				}
			}

			Controls.Button {
				id: applyButton
				text: "Apply"
				enabled: !context.changesApplied
				onClicked: {
					context.applyChanges();
				}
			}
		}
	}
}
