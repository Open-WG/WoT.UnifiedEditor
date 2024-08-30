import QtQuick 2.7
import QtQuick.Controls 2.4
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

Menu {
	id: toolBarMenu

	property var contentView
	property var tableView
	property alias previewSize: previewSizeSlider.value

	property string sortingRole
	property int sortingOrder

	property string viewMode
	property bool naviVisible
	property string displayedName

	signal sortingRoleChosen(string role)
	signal sortingOrderСhosen(int order)

	signal viewModeItemClicked(string viewMode)
	signal displayedNameClicked(string displayedName)
	signal naviItemClicked()

	modal: true

	// Sorting
	MenuHeader { text: "Sort by:" }
	ButtonGroup { id: sortGroup }

	Instantiator {
		id: inst
		model: tableView.columnCount
		readonly property int startIndex: 1

		onObjectAdded: toolBarMenu.insertItem(startIndex + index, object)
		onObjectRemoved: toolBarMenu.removeItem(object)

		MenuItem {
			readonly property var column: tableView.getColumn(index)
			
			checkable: true
			visible: viewMode == "grid" || column.visible
			text: column ? column.title : ""
			ButtonGroup.group: sortGroup
			onClicked: toolBarMenu.sortingRoleChosen(column.role)

			Binding on checked {
				value: column && (column.role == toolBarMenu.sortingRole)
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
		Binding on checked { value: toolBarMenu.sortingOrder == Qt.AscendingOrder }
		onClicked: toolBarMenu.sortingOrderСhosen(Qt.AscendingOrder)
	}

	MenuItem {
		text: "Descending"
		checkable: true
		ButtonGroup.group: sortingOrderGroup
		Binding on checked { value: toolBarMenu.sortingOrder == Qt.DescendingOrder }
		onClicked: toolBarMenu.sortingOrderСhosen(Qt.DescendingOrder)
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
		checked: viewMode == toolBarMenu.viewMode
		text: "Grid"
		icon.source: "image://gui/icon-menu-viewmode-grid"
		ButtonGroup.group: viewModeGroup
		KeyNavigation.up: previewSizeSlider
		onClicked: toolBarMenu.viewModeItemClicked(viewMode)
	}

	MenuItem {
		id: tableViewModeItem
		property string viewMode: "table"
		checkable: true
		checked: viewMode == toolBarMenu.viewMode
		text: "Table"
		icon.source: "image://gui/icon-menu-viewmode-table"
		ButtonGroup.group: viewModeGroup
		onClicked: toolBarMenu.viewModeItemClicked(viewMode)
	}

	// Layout
	MenuSeparator {}
	MenuHeader { text: "Layout:" }

	MenuItem {
		width: parent.width
		text: toolBarMenu.naviVisible ? "Hide Navigation Panel" : "Show Navigation Panel"
		onClicked: toolBarMenu.naviItemClicked()
	}

	// Displayed name
	MenuSeparator {
		visible: toolBarMenu.isGrid()
		height: visible ? implicitHeight : 0
	}
	MenuHeader { 
		visible: toolBarMenu.isGrid()
		height: visible ? implicitHeight : 0
		text: "Displayed name:" 
	}
	
	ButtonGroup { id: displayedNameGroup }

	DisplayedNameMenuItem {
		id: technicalItem
		name: "technical"
		text: "Technical"
	}

	DisplayedNameMenuItem {
		id: localizationItem
		name: "localization"
		text: "Localization"
	}

	function isGrid() {
		return viewMode == "grid"
	}
}
