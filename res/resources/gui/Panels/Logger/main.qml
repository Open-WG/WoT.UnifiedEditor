import QtQuick 2.11
import QtQuick.Controls 1.4 as QuickControls
import QtQuick.Layouts 1.11
import WGTools.Controls 2.0
import WGTools.Controls.impl 1.0 as Impl
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Misc 1.0 as Misc
import WGTools.Views 1.0 as Views

ControlsEx.Panel {
	title: "Notification Center"

	property var margins: 10

	// Manual ButtonGroup
	QtObject {
		id: buttonGroup
		property var buttons: []
		property AbstractButton allButton

		function toggled(button, exclusive) {
			let wasChecked = !button.checked
			if (button == allButton) {
				exclusive = true
			}

			// non exclusive
			if (!exclusive) {

				// can't disable all buttons
				if (wasChecked && otherUnchecked(button)) {
					button.checked = wasChecked
					return
				}

				if (allButton.checked) {
					button.checked = wasChecked
				}
				return
			}

			// exclusive
			button.checked = true
			buttons.forEach(function(b) {
				if (b != button) {
					b.checked = false
			 	}
			})
		}

		function otherUnchecked(button) {
			for (var i = 0; i < buttons.length; i++) {
				var b = buttons[i]
				if (b != button && b.checked == true) {
					return false
				}
			}
			return true
		}
	}

	Misc.SearchingIndicator {
		id: searchIndicator
		width: parent.width
		visible: context.model.isProcessing
		anchors.margins: 3
		anchors.top: parent.top
	}

	RowLayout {
		id: buttonsLayout
		anchors.top: searchIndicator.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: parent.margins

		Repeater {
			model: [{ text: "All", id: [ -1 ]},
					{ text: "Errors", id: [5, 6]},
					{ text: "Warnings", id: [4]},
					{ text: "Info", id: [0, 1, 2, 3]}]

			Button {
				checkable: true
				implicitWidth: 64
				text: modelData.text

				Component.onCompleted: {
					if (modelData.id == -1) {
						checked = true
						buttonGroup.allButton = this
					}
					buttonGroup.buttons.push(this)

					// as attached properties only created on usage, mention it here to create
					Impl.KeyModifiersMonitor.modifiers
				}

				onClicked: {
					buttonGroup.toggled(this, !(Impl.KeyModifiersMonitor.modifiers & Qt.ControlModifier))
				}

				onCheckedChanged: {
					context.model.filterByPriority(modelData.id, checked);
				}
			}
		}

		ControlsEx.SearchField {
			placeholderText: "Filter"
			Layout.fillWidth: true
			onTriggered: {
				context.model.filterByText(text)
			}
		}

		Button {
			text: "Clear"
			implicitWidth: 64
			visible: parent.width > 640
			onPressed: {
				context.model.clear()
			}
		}
	}

	Views.TableView {
		id: tableView
		anchors.top: buttonsLayout.bottom
		anchors.bottom: parent.bottom
		anchors.margins: parent.margins
		width: parent.width

		model: context.model
		headerVisible: true
		selectionMode: QuickControls.SelectionMode.ExtendedSelection

		Connections {
			target: tableView.selection
			onSelectionChanged: {
				context.model.clearSelection()
				tableView.selection.forEach(function(rowIndex) {
					context.model.addRowToSelection(rowIndex)
				})
			}
		}

		property bool __completed: false
		
		Menu {
			id: menu

			Action {
				text: "&Copy"
				shortcut: StandardKey.Copy
				onTriggered: context.model.copySelected()
			}

			Action {
				text: "Select All"
				shortcut: StandardKey.SelectAll
				onTriggered: tableView.selection.selectAll()
			}
		}

		QuickControls.TableViewColumn {
			id: priorityColumn
			title: "Priority"
			role: "priority"
			movable: false
			width: 70

			delegate: ColumnDelegate {
				text: ""
				tooltip: model ? model.priorityName : ""
				implicitWidth: 70

				Impl.ActiveFocus.when: styleData.index == tableView.currentIndex

				Image {
					anchors.centerIn: parent
					id: priorityImage
					fillMode: Image.PreserveAspectFit
					sourceSize: "16x16"
					source: styleData.value != "" ?
						"image://gui/" + styleData.value :
						""
				}
			}
		}
		QuickControls.TableViewColumn {
			id: timeColumn
			title: "Time"
			role: "time"
			movable: false
			width: 70
			delegate: ColumnDelegate {}
		}
		QuickControls.TableViewColumn {
			id: categoryColumn
			title: "Category"
			role: "category"
			movable: false
			width: 70
			delegate: ColumnDelegate {}
		}
		QuickControls.TableViewColumn {
			id: textColumn
			title: "Text"
			role: "display"
			movable: false
			width: 500

			delegate: ColumnDelegate {
				tooltip: model ? model.rawText : ""
				onLinkActivated: context.model.openLink(link)
			}
		}

		property bool autoScroll: true
		property bool scrollAfterProcessing: false

		Connections {
			target: tableView.flickableItem
			onAtYEndChanged: {
				checkAtEndTimer.start()
			}
		}

		Timer {
			id: checkAtEndTimer
			interval: 0
			onTriggered: {
				tableView.autoScroll = (tableView.flickableItem.atYEnd || tableView.focus != true)
			}
		}

		Timer {
			id: scrollTimer
			interval: 0
			onTriggered: {
				if (context.model.isProcessing) {
					tableView.scrollAfterProcessing = true
					return
				}
				tableView.positionViewAtRow(tableView.rowCount - 1, ListView.End)
				tableView.autoScroll = true
			}
		}

		Connections {
			target: context.model
			onModelReset: {
				tableView.selection.clear()
				update()
			}
			onIsProcessingChanged: {
				if (tableView.scrollAfterProcessing) {
					tableView.scrollAfterProcessing = false
					scrollTimer.start()
				}
			}
		}

		onRowCountChanged: {
			if (autoScroll) {
				scrollTimer.start()
			}
		}

		onModelChanged: {
			if (__completed)
				update()
		}

		Component.onCompleted: {
			__completed = true
			update()
		}

		function update() {
			resizeColumnsToContents()
			scrollTimer.start()
		}
	}

	Rectangle {
		Accessible.name: "Scroll Down"
		z: 1
		opacity: 0.7
		anchors.margins: 20
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		radius: 50
		visible: !tableView.flickableItem.atYEnd

		color: mouseArea.containsMouse ? _palette.color8 : "transparent"

		width: 35
		height: 35

		Image {
			id: image
			anchors.centerIn: parent
			fillMode: Image.Pad
			source: "image://gui/btn_arrow_down"
		}

		MouseArea {
			id: mouseArea
			anchors.fill: parent
			acceptedButtons: Qt.LeftButton
			onClicked: {
				tableView.positionViewAtRow(tableView.rowCount - 1, ListView.End)
			}
			hoverEnabled: true
		}
	}
}
