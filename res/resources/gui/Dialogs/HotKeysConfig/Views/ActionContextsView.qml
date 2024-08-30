import QtQuick 2.11
import QtQuick.Controls 1.4
import WGTools.Views 1.0 as Views
import "Details/ActionContextsView" as Details

Views.TreeView {
	id: view
	headerVisible: false
	backgroundVisible: false
	sortIndicatorVisible: true
	alternatingRowColors: false
	accesibleNameRole: "display"
	rowDelegate: Details.RowDelegate {}

	onDoubleClicked: {
		if (index.valid) {
			toggleExpanded(index)
		}
	}

	Connections {
		target: selection
		onCurrentChanged: {
			if (current.valid) {
				view.positionViewAtIndex(current, ListView.Visible)
			} else {
				view.positionViewAtBeginning()
			}
		}
	}

	TableViewColumn {
		role: view.accesibleNameRole
		resizable: true
		delegate: Details.ItemDelegate {
			Component.onCompleted: view.expand(styleData.index)
		}
	}
}

