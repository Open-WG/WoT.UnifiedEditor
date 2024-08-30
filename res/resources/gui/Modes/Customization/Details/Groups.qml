import QtQuick 2.11
import QtQuick.Controls 1.4 as QuickControls
import QtQuick.Layouts 1.11
import QtQml.Models 2.11
import WGTools.Views 1.0 as WGViews
import WGTools.Views.Styles 1.0 as WGViewStyles
import WGTools.Misc 1.0 as WGT

ColumnLayout {
	id: root

	property alias model: view.model
	property alias selection: view.selection
	property var textFilter

	signal rightClicked()
	signal clicked()

	WGViews.TreeView {
		id: view
		headerVisible: false
		// TODO: uncomment in https://jira.wargaming.net/browse/WOTCC-17883
		// selectionMode: QuickControls.SelectionMode.ExtendedSelection
		clip: true

		property var __hoverRow: -1

		style: WGViewStyles.TreeViewStyle {
			rowDelegate: GroupsRowDelegate {}
		}

		Layout.fillWidth: true
		Layout.fillHeight: true

		onClicked: root.clicked()

		Connections {
			target: selection
			onCurrentChanged: {
				view.__currentRow = current.row
			}
		}

		QuickControls.TableViewColumn {
			id: nameColumn
			resizable: true
			horizontalAlignment: Text.AlignLeft
			title: "Name"
			role: "display"
			delegate: GroupsItemDelegate {}
		}

		WGT.FilterResultPlaceholder {
			anchors.verticalCenter: parent.verticalCenter
			width: parent.width
			model: view.model
			searchText: root.textFilter ? root.textFilter.text : ""
		}

		MouseArea {
			anchors.fill: parent
			acceptedButtons: Qt.RightButton
			onClicked: {
				var index = parent.indexAt(mouse.x, mouse.y)
				if (index.valid) {
					if (!parent.selection.isSelected(index)) {
						// TODO: change with the comment in https://jira.wargaming.net/browse/WOTCC-17883
						parent.selection.setCurrentIndex(index, ItemSelectionModel.ClearAndSelect)
						//parent.selection.select(index, ItemSelectionModel.ClearAndSelect)
					}
				} else {
				    parent.selection.clearSelection()
				}
				root.rightClicked()
			}
		}

		// TODO: remove in https://jira.wargaming.net/browse/WOTCC-17883
		TreeViewClearSelectionArea {}
	}
}
