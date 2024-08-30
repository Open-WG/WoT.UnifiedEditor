import QtQuick 2.7
import QtQuick.Layouts 1.3
import Controls 1.0 as SMEControls

import "PropertyGrid"

Rectangle {
	id: root

	color: "#4a4a4a"

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

			SMEControls.Text {
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 15

				width: parent.width - anchors.leftMargin - anchors.rightMargin

				text: smeContext.controller.sequenceName
				elide: Text.ElideRight
				color: "white"

				font.family: "Proxima Nova Th"
				font.pixelSize: 13
			}
		}

		RowLayout {
			id: buttonRow

			spacing: 0
			Layout.fillWidth: true

			SMEControls.Button {
				Layout.fillWidth: true

				text: "New"

				onClicked: {
					forceActiveFocus()
					smeContext.requestNewStateMachine()
				}
			}

			SMEControls.Button {
				Layout.fillWidth: true

				text: "Open"

				onClicked: {
					forceActiveFocus()
					smeContext.requestOpenStateMachine()
				}
			}

			SMEControls.Button {
				Layout.fillWidth: true

				text: "Save"

				onClicked: {
					forceActiveFocus()
					smeContext.requestSaveStateMachine()
				}
			}

			SMEControls.Button {
				Layout.fillWidth: true

				text: "Save As"

				onClicked: {
					forceActiveFocus()
					smeContext.requestSaveAsStateMachine()
				}
			}
		}

		PropertyGrid {
			id: pgRow

			Layout.fillHeight: true
			Layout.preferredWidth: parent.width - Layout.leftMargin - Layout.rightMargin

			Layout.topMargin: 10
			Layout.bottomMargin: 10
			Layout.leftMargin: 10
			Layout.rightMargin: 10

			parameters: smeContext.controller.stateMachineParameters
		}
	}
}