import QtQuick 2.7
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

Menu {
	id: menu

	property var contentView
	property alias previewSize: previewSizeSlider.value

	property string sortingRole
	property int sortingOrder

	property string viewMode
	property bool naviVisible

	signal sortingRoleChosen(string role)
	signal sortingOrderСhosen(int order)

	signal viewModeItemClicked(string viewMode)
	signal naviItemClicked()

	modal: true

	// Sorting
	MenuHeader { text: "Sort by:" }
	ButtonGroup { id: sortGroup }

	Instantiator {
		id: inst
		readonly property int startIndex: 1

		model: [
			{role: "display" , title: "Name"},
			{role: "tags"    , title: "Tags"},
			{role: "created" , title: "Date Created"},
			{role: "modified", title: "Date Last Modified"},
		]

		onObjectAdded: menu.insertItem(startIndex + index, object)
		onObjectRemoved: menu.removeItem(object)

		MenuItem {
			checkable: true
			text: modelData.title
			ButtonGroup.group: sortGroup
			onClicked: menu.sortingRoleChosen(modelData.role)

			Binding on checked {
				value: modelData.role == menu.sortingRole
			}
		}
	}

	// Sorting Order
	MenuHeader { text: "Sorting order:" }
	ButtonGroup { id: sortingOrderGroup }

	MenuItem {
		text: "Ascending"
		checkable: true
		ButtonGroup.group: sortingOrderGroup
		Binding on checked { value: menu.sortingOrder == Qt.AscendingOrder }
		onClicked: menu.sortingOrderСhosen(Qt.AscendingOrder)
	}

	MenuItem {
		text: "Descending"
		checkable: true
		ButtonGroup.group: sortingOrderGroup
		Binding on checked { value: menu.sortingOrder == Qt.DescendingOrder }
		onClicked: menu.sortingOrderСhosen(Qt.DescendingOrder)
	}

	// Preview size
	MenuSeparator {}
	MenuHeader { text: "Preview Size:" }

	Slider {
		id: previewSizeSlider
		Accessible.name: "Preview Size"
		focusPolicy: Qt.StrongFocus
		spacing: 3
		width: parent.width

		ticks.visible: false
		labels.textFromValue: function(value) {
			if (value == from)
				return "min"

			if (value == to)
				return "max"

			return ""
		}

		KeyNavigation.up: inst.count > 0 ? inst.objectAt(inst.count - 1) : null
	}

	// View mode
	MenuSeparator {}
	MenuHeader { text: "View Mode:" }
	ButtonGroup { id: viewModeGroup }

	MenuItem {
		property string viewMode: "grid"
		checkable: true
		checked: viewMode == menu.viewMode
		text: "Grid"
		icon.source: "image://gui/icon-menu-viewmode-grid"
		ButtonGroup.group: viewModeGroup
		KeyNavigation.up: previewSizeSlider
		onClicked: menu.viewModeItemClicked(viewMode)
	}

	MenuItem {
		id: tableViewModeItem
		property string viewMode: "table"
		checkable: true
		checked: viewMode == menu.viewMode
		text: "Table"
		icon.source: "image://gui/icon-menu-viewmode-table"
		ButtonGroup.group: viewModeGroup
		onClicked: menu.viewModeItemClicked(viewMode)
	}

	// Layout
	MenuSeparator {}
	MenuHeader { text: "Layout:" }

	MenuItem {
		width: parent.width
		text: menu.naviVisible ? "Hide Navigation Panel" : "Show Navigation Panel"
		onClicked: menu.naviItemClicked()
	}
}
