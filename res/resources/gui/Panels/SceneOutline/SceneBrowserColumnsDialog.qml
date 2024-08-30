import QtQuick 2.7
import QtQuick.Controls 1.4
import WGTools.Views 1.0 as Views
import WGTools.Controls 2.0 as Controls
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Misc 1.0 as Misc
import QtQuick.Layouts 1.3
import QtQml.Models 2.11
import "Settings.js" as Settings

Rectangle {
	id: root

	property string title: "Edit Columns"

	implicitWidth: 400
	implicitHeight: 400

	property var margings: 4

	color: _palette.color8

	SplitView {
		id: splitView
		anchors.fill: parent
		orientation: Qt.Horizontal

		Item {
			width: 250

			// Filter
			ControlsEx.SearchField {
				id: filter
				anchors.left: parent.left
				anchors.top: parent.top
				anchors.right: parent.right
				anchors.margins: root.margings

				placeholderText: "Filter"

				onTriggered: context.setColumnsFilter(text)
			}

			// Checkable tree view
			Views.TreeView {
				id: treeView
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.top: filter.bottom
				anchors.bottom: parent.bottom
				anchors.margins: root.margings

				model: context.checkableColumnsModel
				headerVisible: false

				Views.TableViewColumn {
					role: "display"
				}

				itemDelegate: Row {
					spacing: Settings.defaultSpacing
					Controls.CheckBox {
						id: checkbox
						anchors.verticalCenter: parent.verticalCenter
						visible: treeView.model && (treeView.model.flags(styleData.index) & Qt.ItemIsUserCheckable)

						checkState: model ? model.checked : 0

						onClicked: {
							model.checked = checkState
						}
					}

					Misc.Text {
						anchors.verticalCenter: parent.verticalCenter
						verticalAlignment: Text.AlignVCenter
						text: styleData ? styleData.value : ""
						color: _palette.color1
					}
				}
			}
		}

		ColumnLayout {
			Layout.fillWidth: true

			Views.TreeView {
				Layout.fillHeight: true
				Layout.fillWidth: true
				model: context.selectedColumnsModel
				headerVisible: true
				alternatingRowColors: false
				anchors.margins: root.margings

				selectionMode : SelectionMode.ExtendedSelection
				selection: ItemSelectionModel {
					id: visibleColumnsSelection
					model: context.selectedColumnsModel
				}

				TableViewColumn {
					role: "fullName"
					title: "Visible Columns"

					delegate: Misc.Text {
						verticalAlignment: Text.AlignVCenter
						text: styleData.value != undefined ? styleData.value : ""
					}
				}
			}

			RowLayout {
				Layout.margins: 10

				Controls.Button {
					Layout.fillWidth: true
					implicitWidth: 50

					text: "Remove selected"
					onClicked: context.removeFromSelectedColumns(visibleColumnsSelection.selectedIndexes)
				}
				Controls.Button {
					Layout.fillWidth: true
					implicitWidth: 50
					text: "Clear"
					onClicked: context.clearSelectedColumns()
				}
			}
		}
	}
}