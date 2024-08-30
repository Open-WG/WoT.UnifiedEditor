import QtQuick 2.11
import QtQml.Models 2.11
import WGTools.Controls 2.0
import WGTools.Models 1.0

GridView {
	id: view

	signal clickedOutSide(var mouse)

	property ItemSelectionModel selection: null
	readonly property GridViewSelector selector: GridViewSelector {
		target: view
		selection: view.selection

		// TODO: remove in https://jira.wargaming.net/browse/WOTCC-17883
		selectionMode: GridViewSelector.SingleSelection
	}

	property alias textFilter: placeholder.textFilter
	property alias quickFilters: placeholder.quickFilters

	// highlight: Rectangle {color: "tomato"; opacity: 0.2} // due to Debug purposes
	cellWidth: 100
	cellHeight: 120
	clip: true

	Keys.onPressed: {
		if (event.key == Qt.Key_Escape && view.selection && view.selection.hasSelection) {
			view.selection.clear();
			event.accepted = true;
		}
	}

	ScrollBar.vertical: ScrollBar {}

	ElementsPlaceholder {
		id: placeholder
		model: view.model
		width: parent.width
		anchors.verticalCenter: parent.verticalCenter
	}

	MouseArea {
		width: parent.width
		height: view.height
		y: view.contentY
		parent: view.contentItem
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		hoverEnabled: false

		onClicked: {
			view.forceActiveFocus(Qt.MouseFocusReason)

			var clickedIndex = view.indexAt(mouse.x, mouse.y - y)
			if (clickedIndex == -1) {
				clickedOutSide(mouse)
			} else {
				mouse.accepted = false
			}
		}
	}
}
