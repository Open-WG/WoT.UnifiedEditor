import QtQml.Models 2.11
import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 1.4 as C1
import WGTools.ControlsEx 1.0 as CEx

Window {
	width: 800
	height: 600
	visible: true

	Rectangle {
		anchors.fill: parent
		anchors.rightMargin: tree.width

		CEx.FiltersView {
			id: filters
			width: parent.width
			model: ListModel {
				id: testModel
				ListElement {display: "filter1"}
				ListElement {display: "filter2"}
				ListElement {display: "filter3"}
				ListElement {display: "filter4"}
				ListElement {display: "filter5"}
				ListElement {display: "filter6"}
				ListElement {display: "filter7"}
				ListElement {display: "filter8"}
				ListElement {display: "filter9"}
				ListElement {display: "filter10"}
			}
		}
	}

	C1.TreeView {
		id: tree
		model: testModel
		selection: filters.selection
		selectionMode: C1.SelectionMode.MultiSelection

		width: 200
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.bottom: parent.bottom

		C1.TableViewColumn {
			role: "display"
		}
	}
}