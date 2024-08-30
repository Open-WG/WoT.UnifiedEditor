import QtQuick 2.11
import WGTools.Views 1.0
import "Delegates" as Delegates

TreeView {
	id: view
	headerVisible: true

	TableViewColumn {
		title: "Path"
		resizable: false
		width: view.width / 2
		delegate: Delegates.Path {}
	}

	TableViewColumn {
		title: "Error"
		role: "error"
		resizable: false
		width: view.width / 2
	}

	Connections {
		target: view.selection
		onSelectionChanged: {
			var indexes = view.selection.selectedIndexes
			if (indexes.length == 1) {
				lookAtIndex(indexes[0])
			}
		}
	}

	 function lookAtIndex(index) {
		if (index.valid) {
			view.expandAllParents(index)
			view.positionViewAtIndex(index, ListView.Contain)
		} else {
			view.positionViewAtBeginning()
		}
	}
}
