import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import WGTools.Controls 2.0 as Controls
import WGTools.Misc 1.0 as Misc
import WGTools.Shapes 1.0 as Shapes

import "Constants.js" as Constants

Rectangle {
	id: root
	Accessible.name: "Sequence"

	color: "black"
	border.color: Constants.labelBorderColor

	Misc.Text{
		id: sequenceName

		anchors.left: parent.left
		anchors.verticalCenter : parent.verticalCenter
		anchors.leftMargin: Constants.seqSaveLoadItemsMargin

		text: getText()

		function getText() {
			if (!context.sequenceModel)
				return ""

			return context.sequenceModel.sequenceName == ""
				? "Create Sequence"
				: context.sequenceModel.sequenceName
		}

		color: "white"
	}

	Shapes.Triangle {
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		anchors.rightMargin: 5

		width: 12
		height: 6

		color: "white"
	}

	MouseArea {
		anchors.fill: parent

		hoverEnabled: true

		onEntered: {
			root.opacity = 0.8
		}

		onExited: {
			root.opacity = 1
		}

		onClicked: {
			if (popup.visible)
				popup.close()
			else
				popup.open()
		}
	}

	Controls.Menu {
		id: popup
		Accessible.name: "Menu"

		readonly property var imageSize: 16
		readonly property var layoutSpacing: 8

		x: root.x
		y: root.y + root.height

		width: root.width

		Controls.MenuItem {
			id: createSeqItem
			Accessible.name: "Create Sequence"

			height: 25
			width: parent.width

			contentItem: RowLayout {
				spacing: popup.layoutSpacing

				Image {
					source: Constants.iconAddButton
					sourceSize.width: popup.imageSize
					sourceSize.height: popup.imageSize
				}

				Misc.Text {
					text: "Create Sequence"

					Layout.fillWidth: true

					color: Constants.fontColor

					font.family: Constants.proximaRg
					font.bold: true
					font.pixelSize: 12
				}
			}

			onTriggered: context.createSequence()
		}

		Controls.MenuItem {
			height: 25
			width: parent.width
			Accessible.name: "Open Sequence"

			contentItem: RowLayout {
				spacing: popup.layoutSpacing

				Image {
					source: Constants.iconOpen
					sourceSize.width: popup.imageSize
					sourceSize.height: popup.imageSize
				}

				Misc.Text {
					text: "Open Sequence"

					color: Constants.fontColor

					font.family: Constants.proximaRg
					font.bold: true
					font.pixelSize: 12

					Layout.fillWidth: true
				}
			}

			onTriggered: context.openSequence()
		}

		Controls.MenuItem {
			height: 25
			width: parent.width
			Accessible.name: "Save Sequence"

			contentItem: RowLayout {
				spacing: popup.layoutSpacing

				Image {
					source: Constants.iconSave
					sourceSize.width: popup.imageSize
					sourceSize.height: popup.imageSize
				}

				Misc.Text {
					text: "Save Sequence"

					color: Constants.fontColor

					font.family: Constants.proximaRg
					font.bold: true
					font.pixelSize: 12

					Layout.fillWidth: true
				}
			}

			onTriggered: context.saveSequence()
		}
	}
}