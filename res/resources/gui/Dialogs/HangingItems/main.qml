import QtQuick 2.10
import QtQuick.Controls 1.4
import WGTools.Controls 2.0 as Controls
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Controls.Details 2.0 as Details
import QtQuick.Layouts 1.3
import WGTools.Views 1.0 as Views
import WGTools.Views.Styles 1.0 as Styles

ControlsEx.Panel {
	id: dlg
	
	property var title: "Hanging items"

	implicitWidth: 770
	implicitHeight: 800
	color: _palette.color7

	Accessible.name: title

	Views.TreeView {
		id : view
		model: context.model
		selection: context.selectionModel
		implicitHeight: parent.height - footer.height
		implicitWidth : dlg.width
		anchors.top: parent.top
		anchors.left : parent.left
		anchors.right : parent.right

		sortIndicatorColumn: 2

		selectionMode : SelectionMode.ExtendedSelection 
		sortIndicatorVisible : true

		TableViewColumn {
			role: "type"
			title: "Type"
			width: dlg.width / 6
		}
		TableViewColumn {
			role: "display"
			title: "Name"
			width: dlg.width  / 2
		}
		TableViewColumn {
			role: "deviation"
			title: "Deviation"
			width: dlg.width / 3
		}

		onDoubleClicked: {
			context.model.onDoubleClicked(index)
		}

		onSortIndicatorColumnChanged: {
			sort()
		}
		onSortIndicatorOrderChanged: {
			sort()
		}
		function sort() {
			var roleName = view.getColumn(sortIndicatorColumn).role
			context.model.setSorting(roleName, sortIndicatorOrder)
		}

		Connections {
			target: view.selection
			onSelectionChanged: {
				var indexes = view.selection.selectedIndexes
				if (indexes.length == 1) {
					view.lookAtIndex(indexes[0])
				}
			}
		}

		function lookAtIndex(index) {
			if (index.valid) {
				view.expandAllParents(index)
				view.positionViewAtIndex(index, ListView.Visible)
			} else {
				view.positionViewAtBeginning()
			}
		}

	}

	Rectangle {
		id: footer
		color: _palette.color8
		implicitHeight: 40
		anchors.bottom: parent.bottom
		anchors.left : parent.left
		anchors.right : parent.right

		Rectangle {
			id: separator
			color: _palette.color9
			width: parent.width
			height: 1
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
		}

		RowLayout {
			spacing: 10
			anchors.top: parent.top
			anchors.topMargin: 8
			anchors.left: parent.left

			Controls.Button {
				id: fixButton
				text: "Fix"

				implicitWidth: ControlsSettings.width
				implicitHeight: 25
				Layout.leftMargin: 5

				onClicked: context.model.onFixHangingItemsClicked(whatToFix.currentIndex == 0, howToFix.currentIndex == 0)
			}

			Text {
				id: totalCount
				text: "Total: " + context.model.rowCount()
				color: _palette.color1
			}

			Connections {
				target: context.model
				onModelReset: totalCount.text = "Total: " + context.model.rowCount()
			}

			Text {
				Layout.leftMargin: 5
				text: "What to fix"
				color: _palette.color2
			}
			Controls.ComboBox {
				id: whatToFix
				implicitWidth: 120
				implicitHeight: 25
				currentIndex: 0
				model: ["All","Selection"]
			}

			Text {
				text: "How to fix"
				color: _palette.color2
			}
			Controls.ComboBox {
				id: howToFix
				implicitWidth: 120
				implicitHeight: 25
				currentIndex: 0
				model: ["Snap To ground","Add Height"]
			}

			Text {
				text: "Add Height"
				color: _palette.color2
				enabled: howToFix.currentIndex == 1
			}
			Controls.TextField {
				id: addHeightEdit
				enabled: howToFix.currentIndex == 1
				text: "0.0"
				onTextEdited: {
					context.model.setAddHeight(text)
				}
			}
		}
	}
}
