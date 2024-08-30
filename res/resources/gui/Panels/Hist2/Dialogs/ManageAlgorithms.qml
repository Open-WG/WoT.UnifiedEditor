import QtQuick 2.11
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0 as ControlDetails
import WGTools.Views 1.0 as Views
import WGTools.Views.Details 1.0 as ViewDetails
import WGTools.Views.Styles 1.0 as ViewStyles
import WGTools.Misc 1.0 as Misc
import WGTools.HIST 1.0 as Hist

import "../Details" as Details

Rectangle {
	property int minimumHeight: 500
	property int minimumWidth: 400

	color: _palette.color7

	Accessible.name: qmlView.title

	ColumnLayout {
		anchors {
			fill: parent
			topMargin: 8
			bottomMargin: 8
		}
		spacing: 6

		Views.TreeView {
			id: filesystemTree
			Layout.fillWidth: true
			Layout.fillHeight: true

			headerVisible: true
			selectionMode: SelectionMode.NoSelection
			model: context.controller.assetTree

			TableViewColumn {
				id: nameColumn

				title: "Path"
				resizable: false
				width: filesystemTree.width / 2

				delegate: Controls.Control {
					Controls.ToolTip.text: fileName.text
					Controls.ToolTip.visible: hovered && fileName.truncated
					hoverEnabled: true

					contentItem: RowLayout {
						spacing: 8
						Layout.alignment: Qt.AlignLeft
						Image {
							source: model && model.icon ? "image://gui/" + model.icon : ""
							smooth: true
							fillMode: Image.Pad
						}
						Misc.Text {
							id: fileName
							Layout.fillWidth: true
							text: model ? (model.displayName ? model.displayName : model.fileName) : ""
							elide: styleData.elideMode
							color: _palette.color2
							verticalAlignment: Text.AlignVCenter
						}
					}
				}
			}

			TableViewColumn {
				title: "Algorithm"
				resizable: false
				width: filesystemTree.width / 2

				delegate: Item {
					id: test
					readonly property var _assignedAlgoName: model ? model.assignedAlgorithm : ""
					readonly property var _path: model ? model.filePath : ""
					readonly property var _override: model ? model.pathOverride : ""

					Misc.Text {
						id: algoLabel
						anchors.fill: parent
						visible: true
						text: _assignedAlgoName
						verticalAlignment: Text.AlignVCenter
					}

					Controls.ComboBox {
						id: algoCombo
						visible: false
						anchors.fill: parent
						model: context.algorithms

						delegate: ControlDetails.ComboBoxDelegate {
							property var control: algoCombo
							text: model.name
						}

						onActivated: {
							context.controller.assignAlgorithmForResource(
								textAt(index), 
								_override != "" && _override != undefined ? _override : _path)
						}

						onVisibleChanged: {
							if (visible) {
								currentIndex = find(_assignedAlgoName);
							}
						}
					}

					MouseArea {
						anchors.fill: parent
						hoverEnabled: true
						acceptedButtons: Qt.NoButton
						onEntered: {
							algoCombo.visible = true
							algoLabel.visible = false
						}
						onExited: {
							algoCombo.visible = false
							algoLabel.visible = true
						}
					}
				}
			}
		}
	}
}
