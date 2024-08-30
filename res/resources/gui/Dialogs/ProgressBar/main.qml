import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import WGTools.Controls 2.0 as Controls
import WGTools.Misc 1.0 as Misc
import WGTools.Debug 1.0 as Debug
import WGTools.Views 1.0 as Views
import WGTools.Views.Styles 1.0 as Styles
import WGTools.Misc 1.0 as Misc

ColumnLayout {
	id: root

	property var title: context.title

	spacing: 0
	anchors.fill: parent

	Accessible.name: title

	Rectangle {
		id: status
		
		Layout.fillWidth: true

		implicitHeight: 130

		color: _palette.color8
		
		Text {
			id: message
			text: context.message
			 
			font.pointSize: 12
			color: _palette.color1
			
			anchors.topMargin: 15
			anchors.leftMargin: 25

			anchors.top: parent.top
			anchors.left : parent.left
			anchors.right : parent.right
		}
		
		Text {
			id: progressInfo
			text: context.progress
			 
			font.pointSize: 18
			font.weight: Font.Medium
			
			color: _palette.color1
			
			anchors.top: message.bottom
			anchors.left : parent.left
			anchors.right : parent.right
			
			anchors.topMargin: 10
			anchors.leftMargin: 25
		}
		
		Controls.ProgressBar {
			id: progress
			indeterminate: context.indeterminate
			
			implicitWidth: 390
			implicitHeight: 13
			
			value: context.value
			
			anchors.horizontalCenter: parent.horizontalCenter
			
			anchors.top: progressInfo.bottom
			anchors.topMargin: 20
			anchors.bottomMargin: 21
			anchors.leftMargin: 25
			anchors.rightMargin: 25
		}
	}
	
	Rectangle {
		id: footer

		Layout.fillWidth: true
		Layout.fillHeight: details.visible ? false : true

		color: _palette.color8
		implicitHeight: 48
		
		Rectangle {
			id: separator
			color: _palette.color9
			width: parent.width
			height: 1
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
		}
		
		Controls.Button {
			id: moreDetailsButton
			text: "More details"
			flat: true
			icon.source: details.visible
				? "image://gui/expand"
				: "image://gui/collapse"
			icon.color: "#8c8c8c"

			anchors.topMargin: (footer.implicitHeight - height) / 2
			anchors.top: parent.top

			onClicked: {
				if (details.visible) {
					details.visible = false
					details.height = 0
				}
				else {
					details.visible = true
					details.height = 200
				}
				context.fitToContent()
			}

		    Binding {
				target: moreDetailsButton.contentItem
				property: "text"
				value: moreDetailsButton.text
			}
		}

		Controls.Button {
			id: ok
			text: "Ok"
			implicitWidth: 70
			
			anchors.rightMargin: 5
			anchors.topMargin: (footer.implicitHeight - height) / 2
			anchors.right: cancel.visible ? cancel.left : parent.right
			anchors.top: parent.top
			enabled: context.done
			
			onClicked: context.accept()
		}
		
		Controls.Button {
			id: cancel
			visible : context.stoppable
			enabled: !context.canceled && !context.done
			text: "Cancel"
			implicitWidth: 70

			anchors.rightMargin: 5
			anchors.topMargin: (footer.implicitHeight - height) / 2
			anchors.right: parent.right
			anchors.top: parent.top

			onClicked: context.reject()
		}
	}

	Rectangle {
		id: detailsSeparator

		Layout.fillWidth: true

		color: "black"
		width: parent.width
		height: 1
		visible: details.visible
	}

	Rectangle {
		id: details

		Layout.fillHeight: true
		Layout.fillWidth: true

		color: _palette.color5
		visible: true

		Views.TableView {
			id: messageTable

			property var lastRowSelected: false

			anchors.fill: parent
			
			model: context.messages
			headerVisible: false
			selectionMode: SelectionMode.SingleSelection
			style: Styles.TableViewStyle {
				backgroundColor: _palette.color8
			}

			TableViewColumn {
				id: messageColumn

				delegate: Misc.Text {
					text: model ? model.itemMessage : ""
				}
			}
			
			Connections {
				target: messageTable.selection
				onSelectionChanged: {
					messageTable.lastRowSelected =
						messageTable.rowCount == 0
						? false
						: messageTable.selection.contains(messageTable.rowCount - 1)
				}
			}

			Shortcut {
				sequence: "Ctrl+End"
				onActivated: {
					messageTable.selection.clear()
					if (messageTable.rowCount) {
						messageTable.selection.select(messageTable.rowCount - 1)
						updateTimer.running = true
					}
				}
			}

			onRowCountChanged: {
				if (messageTable.selection.count == 0 || messageTable.lastRowSelected)
					updateTimer.running = true
			}

			function lastRowSelected() {
				messageTable.selection.select(messageTable.rowCount - 1)
			}

			Timer {
				id: updateTimer
				interval: 50
				repeat: false

				onTriggered: {
					if (messageTable.selection.count == 0 || messageTable.lastRowSelected) {
						messageTable.positionViewAtRow(messageTable.rowCount - 1, ListView.End)

						if (messageTable.lastRowSelected) {
							messageTable.selection.clear()
							messageTable.selection.select(messageTable.rowCount - 1)
						}
					}
				}
			}
		}

		Component.onCompleted: details.visible = false
	}
}
