import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "Constants.js" as Constants
import "Buttons"
import "Debug"

Item {
	id: root

	clip: true

	property alias model: repeater.model
	property var scaleController: null
	property var context: null

	Rectangle {
		visible: context.sequenceOpened && context.modelSelected

		color: "transparent"

		anchors.fill: parent

		Repeater {
			id: repeater

			delegate: Rectangle {
				height: parent.height
				width: Constants.strokeWidth

				x: Math.round(model.position)

				anchors.bottom : parent.bottom

				color: "black"
				opacity: model.majorityCoeff
			}
		}
	}

	Rectangle {
		visible: !context.sequenceOpened || !context.modelSelected

		width: 381
		height: 262

		radius: 3

		anchors.centerIn: parent
		color: "transparent"

		ColumnLayout {
			visible: !context.sequenceOpened || !context.modelSelected
			
			width: parent.width
			anchors.top: parent.top
			anchors.topMargin: 13

			Image {
				Layout.alignment: Qt.AlignHCenter

				source: Constants.noSequenceTransition
			}

			Text {
				Layout.alignment: Qt.AlignHCenter

				text: context.modelSelected ? "No sequence opened" : "No model selected"
				
				color: Constants.fontColor

				font.pixelSize: 18
				font.family: Constants.proximaRg
				font.bold: true
			}

			Text {
				visible: context.modelSelected

				Layout.alignment: Qt.AlignHCenter
				text: "To start creating animation open or create sequence file"
				
				color: Constants.fontColor

				font.family: Constants.proximaRg
				font.pixelSize: 12
				font.bold: true
			}

			RowLayout {

				visible: context.modelSelected
				Layout.alignment: Qt.AlignHCenter
				Layout.topMargin: 12
				TimelineButton {
					padding: 4

					text: "Create"

					onClicked: {
						context.createSequence()
					}
				}

				Text {
					visible: context.modelSelected

					Layout.alignment: Qt.AlignHCenter
					text: "or"
					
					color: Constants.fontColor

					font.family: Constants.proximaRg
					font.pixelSize: 12
					font.bold: true
				}

				TimelineButton {
					padding: 4
					
					text: "Open"
					
					onClicked: {
						context.openSequence()
					}
				}
			}
		}
	}
}
