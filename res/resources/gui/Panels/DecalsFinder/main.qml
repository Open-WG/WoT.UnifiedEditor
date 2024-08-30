import QtQuick 2.11
import QtQml.Models 2.11
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0 as Controls
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Views 1.0 as Views
import WGTools.Views.Styles 1.0 as ViewStyles
import WGTools.Styles.Text 1.0 as StyledText

import WGTools.PropertyGrid 1.0
import Panels.PropertyGrid.View 1.0 as PGView

ControlsEx.Panel {
	id: decalsFinder

	title: "Decals"
	layoutHint: "bottom"
	property var margins: 10

	ColumnLayout {
		anchors.fill: parent

		PGView.PropertyGrid {
			Layout.fillWidth: true
			height: contentHeight
			model: PropertyGridModel {
				id: pgModel
				source: context.refObject
				changesController: context.changesController
			}

			selection: ItemSelectionModel {
				id: pgSelection
				model: pgModel
			}
		}

		Views.TreeView {
			id: view
			model: context.model
			selection: context.selectionModel
			selectionMode: SelectionMode.ExtendedSelection
			Layout.fillWidth: true
			Layout.fillHeight: true

			headerVisible: true
			alternatingRowColors: false
			style: ViewStyles.TreeViewStyle{
				backgroundColor: _palette.color8
			}

			// column menu
			Controls.Menu {
				id: menu
				Controls.MenuItem {
					text: "Copy to clipboard"
					onTriggered: context.copyToClipboard()
				}
			}
	
			sortIndicatorVisible: true
			onSortIndicatorColumnChanged: {
				sort()
			}

			onSortIndicatorOrderChanged: {
				sort()
			}

			function sort() {
				var roleName = view.getColumn(sortIndicatorColumn).role
				model.sortByRole(roleName, sortIndicatorOrder)
			}

			Connections {
				target: context.model
				ignoreUnknownSignals: true
				onSortingChanged: {
					var role = context.model.sortRole
					var order = context.model.sortOrder
					for (var i = 0; i < view.columnCount; i++) {
						if (context.model.roleByName(view.getColumn(i).role) == role) {
							view.sortIndicatorColumn = i
							view.sortIndicatorOrder = order
							return
						}
					}
				}
			}

			Connections {
				onDoubleClicked: {
					if (index.valid) {
						context.onDoubleClicked(index);
					}
				}
			}

			Component {
				id: columnDelegate
				StyledText.BaseRegular {
					text: typeof styleData.value == "number" ?
						styleData.value.toFixed(2) : styleData.value
					verticalAlignment: Text.AlignVCenter
					elide: Text.ElideRight
					padding: 10

					MouseArea {
						anchors.fill: parent
						acceptedButtons: Qt.RightButton 
						onPressed: menu.popupEx()
					}
				}
			}

			TableViewColumn {
				title: "Decal texture"
				role: "display"
				width: 200
				delegate: columnDelegate
			}

			TableViewColumn {
				title: "Height"
				role: "height"
				width: 50
				delegate: columnDelegate
			}

			TableViewColumn {
				title: "x"
				role: "posX"
				width: 50
				delegate: columnDelegate
			}
			TableViewColumn {
				title: "y"
				role: "posY"
				width: 50
				delegate: columnDelegate
			}
			TableViewColumn {
				title: "z"
				role: "posZ"
				width: 50
				delegate: columnDelegate
			}
		}
	}
}