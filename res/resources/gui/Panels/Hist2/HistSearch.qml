import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.ControlsEx 1.0
import WGTools.Controls 2.0 as Controls
import WGTools.HIST 1.0 as Hist
import "Details" as Details

ColumnLayout {
	spacing: 5

	Controls.Label {
		text: "Search"
	}
	
	SearchField {
		id: filter
		placeholderText: "Filter"
		text: context.filteredResults.filterTokens
		Layout.fillWidth: true

		Binding {
			target: context.filteredResults
			property: "filterTokens"
			value: filter.text
		}
	}

	HistSearchResults {
		Layout.fillWidth: true
		Layout.fillHeight: true
	}

	Details.Separator {
		Layout.fillWidth: true
	}

	RowLayout {
		Layout.leftMargin: 10
		Layout.rightMargin: 10
		
		Controls.RadioButton {
			Layout.fillWidth: true
			text: "All"
			checked: context.selectionMode == Hist.SelectionMode.ALL
			onToggled: context.selectionMode = Hist.SelectionMode.ALL
		}

		Controls.RadioButton {
			Layout.fillWidth: true
			text: "Selected"
			checked: context.selectionMode == Hist.SelectionMode.SELECTED
			onToggled: context.selectionMode = Hist.SelectionMode.SELECTED
		}
	}

	RowLayout {
		Controls.Button {
			Layout.fillWidth: true
			text: "Start Search"

			onClicked: context.search()
		}

		Controls.Button {
			Layout.fillWidth: true
			text: "Fix Objects"

			onClicked: context.fixObjects()
		}
	}
}
