import QtQuick 2.11
import QtQuick.Layouts 1.3
import Panels.SequenceTimeline 1.0

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
					Accessible.name: labelText.text

					property alias labelTextWidth: labelText.width
					property alias valueTextWidth: valueText.width

					Layout.margins: 0

					height: Constants.curveValueDisplayHeight
					visible: !model.disabled

					Rectangle {
						id: displayHolder

						implicitWidth: valueRepeater.displayHolderImpWidth

						Layout.fillHeight: true

						radius: 3
						color: "black"

						Text {
							id: labelText
							Accessible.name: "Label"

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
							Accessible.name: "Value"

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
						Accessible.name: "Visibility"

						fillMode: Image.Pad

						Layout.maximumHeight: Constants.curveValueDisplayHeight
						Layout.rightMargin: 12

						opacity: model.visible ? 1 : 0.2

						MouseArea {
							anchors.fill: parent

							onPressed: model.visible = !model.visible
						}
					}
				}
			}
		}
	}
}
