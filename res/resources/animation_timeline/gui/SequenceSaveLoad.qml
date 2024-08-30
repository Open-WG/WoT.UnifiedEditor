import QtQuick 2.7
import QtQuick.Controls 2.0
import Controls 1.0 as TControls
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import WGTools.Shapes 1.0 as Shapes
import "Constants.js" as Constants
import "Debug"

Rectangle {
	id: root

	color: "black"
	border.color: Constants.labelBorderColor

	property var context: null

	Text{
		id: sequenceName

		anchors.left: parent.left
		anchors.verticalCenter : parent.verticalCenter
		anchors.leftMargin: Constants.seqSaveLoadItemsMargin

		text: root.context.sequenceName == "" ? "Create Sequence" : root.context.sequenceName

		font.pixelSize: 12
		font.family: Constants.proximaRg
		font.bold: true

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
			popup.open()
		}
	}

	TControls.Menu {
		id: popup

		readonly property var imageSize: 16
		readonly property var layoutSpacing: 8

		x: root.x
		y: root.y + root.height

		width: root.width

		TControls.MenuItem {
			id: createSeqItem

			height: 25
			width: parent.width

			contentItem: RowLayout {
				spacing: popup.layoutSpacing

				Image {
					source: Constants.iconAddButton
					sourceSize.width: popup.imageSize
					sourceSize.height: popup.imageSize
				}

				Text {
					text: "Create Sequence"

					Layout.fillWidth: true

					color: Constants.fontColor

					font.family: Constants.proximaRg
					font.bold: true
					font.pixelSize: 12
				}
			}

			onTriggered: {
				root.context.createSequence()
			}
		}

		TControls.MenuItem {
			height: 25
			width: parent.width

			contentItem: RowLayout {
				spacing: popup.layoutSpacing

				Image {
					source: Constants.iconOpen
					sourceSize.width: popup.imageSize
					sourceSize.height: popup.imageSize
				}

				Text {
					text: "Open Sequence"

					color: Constants.fontColor

					font.family: Constants.proximaRg
					font.bold: true
					font.pixelSize: 12

					Layout.fillWidth: true
				}
			}

			onTriggered: {
				root.context.openSequence()
			}
		}

		TControls.MenuItem {
			height: 25
			width: parent.width

			contentItem: RowLayout {
				spacing: popup.layoutSpacing

				Image {
					source: Constants.iconSave
					sourceSize.width: popup.imageSize
					sourceSize.height: popup.imageSize
				}

				Text {
					text: "Save Sequence"

					color: Constants.fontColor

					font.family: Constants.proximaRg
					font.bold: true
					font.pixelSize: 12

					Layout.fillWidth: true
				}
			}

			onTriggered: {
				root.context.saveSequence()
			}
		}
	}
}