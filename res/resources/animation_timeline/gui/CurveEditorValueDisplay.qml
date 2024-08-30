import QtQuick 2.7
import QtQuick.Layouts 1.3

import "Constants.js" as Constants
import "Debug"

Item {
	id: editorView

	height: Constants.curveEditorHeight
	clip: true
	
	Rectangle {
		anchors.fill: parent

		color: Constants.curveEditorBackgroundColor

		Column {
			height: editorView.height

			anchors.right: parent.right

			spacing: {
				var heightSum = 0
				for (var i = 0; i < valueRepeater.count; ++i) {
					heightSum += valueRepeater.itemAt(i).height
				}

				heightSum += topPadding;
				heightSum += bottomPadding

				var newSpacing = (height - heightSum) / (valueRepeater.count - 1)
				return newSpacing > 8 ? 8 : newSpacing
			}

			topPadding: Constants.curveValueDisplayTopBotPadding
			bottomPadding: Constants.curveValueDisplayTopBotPadding

			Repeater {
				id: valueRepeater

				property var displayHolderImpWidth: Constants.curveValueDisplayWidth

				model: styleData.proxy ? styleData.proxy.elements : null
				anchors.left: parent.left

				function getDisplayHolderImpWidth() {
					var maxWidth = 0
					for (var i = 0; i < valueRepeater.count; ++i) {
						var dispItem = valueRepeater.itemAt(i)
						var val = dispItem ? valueRepeater.itemAt(i).valueTextWidth : 0
						val += dispItem ? valueRepeater.itemAt(i).labelTextWidth : 0

						if (val > maxWidth) {
							maxWidth = val
						}
					}

					return maxWidth
				}

				Component.onCompleted: valueRepeater.displayHolderImpWidth = valueRepeater.getDisplayHolderImpWidth()

				delegate: RowLayout {
					id: rowDel

					readonly property var labelTextWidth: labelText ? labelText.width : 0
					readonly property var valueTextWidth: valueText ? valueText.width : 0

					anchors.left: parent.left
					Layout.margins: 0

					height: Constants.curveValueDisplayHeight

					Rectangle {
						id: displayHolder

						implicitWidth: valueRepeater.displayHolderImpWidth

						anchors.top: parent.top
						anchors.bottom: parent.bottom

						radius: 3
						color: "black"

						Text {
							id: labelText

							text: model.label
							color: model.color

							anchors.verticalCenter: parent.verticalCenter
							anchors.left: parent.left

							font.family: Constants.proximaRg
							font.bold: true
							font.pixelSize: 12

							leftPadding: 7
							rightPadding: 8

							onWidthChanged: {
								valueRepeater.displayHolderImpWidth = 
									valueRepeater.getDisplayHolderImpWidth()
							}
						}

						Text {
							id: valueText

							text: model.value.toFixed(3)

							font.family: Constants.proximaRg
							font.bold: true
							font.pixelSize: 12

							color: "white"


							anchors.right: parent.right
							anchors.verticalCenter: parent.verticalCenter
							rightPadding: 7

							onWidthChanged: {
								valueRepeater.displayHolderImpWidth = 
									valueRepeater.getDisplayHolderImpWidth()
							}

							Connections {
								target: styleData.context.playbackController
								ignoreUnknownSignals: true
								onCurrentSampleChanged: {
									valueText.text = model.value.toFixed(3)
								}
							}
						}
					}

					Image {
						source: Constants.iconVisibility
						sourceSize.width: Constants.seqTreeIconWidth
						sourceSize.height: Constants.seqTreeIconHeight

						fillMode: Image.Pad

						Layout.maximumHeight: Constants.curveValueDisplayHeight
						Layout.rightMargin: 12

						opacity: model.visible ? 1 : 0.2

						MouseArea {
							anchors.fill: parent

							onClicked: model.visible = !model.visible
						}
					}
				}
			}
		}
	}
}
