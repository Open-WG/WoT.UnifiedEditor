import QtQuick 2.11
import QtQuick.Controls 1.4 as QuickControls
import QtQuick.Layouts 1.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Misc 1.0 as Misc
import WGTools.Views 1.0

ControlsEx.Panel {
	id: modelValidator
	title: "Validator"
	layoutHint: "bottom"
	
	function severityColor(severityName) {
		switch (severityName)
		{
			case "high":   return _palette.color14
			case "medium": return _palette.color15
			case "normal": return _palette.color16
			case "none":   return _palette.color2
			default:       return _palette.color2
		}
	}

	Rectangle {
		width: animation.width;
		height: animation.height;
		color: _palette.color7
		visible: context.inProgress

		AnimatedImage {
			id: animation;
			//source: context.gifPath
			source: "../../../images/load.gif"
		}

		Text {
			text: "Validation in progress..."
			anchors.top: animation.bottom
			anchors.topMargin:5
			anchors.horizontalCenter: parent.horizontalCenter
			color: _palette.color2
		}
		
		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter
	}

	Image {
		anchors.fill: parent
		source: "image://gui/model-validate-success"
		fillMode: Image.PreserveAspectFit 
		visible: (!context.inProgress && context.model.rowCount() == 0)
	}

	ColumnLayout {
		anchors.fill: parent 
		spacing: 2
		visible: (!context.inProgress && context.model.rowCount() > 0)

		TableView {
			id: tableView
			model: context.model
			selectionMode: QuickControls.SelectionMode.ExtendedSelection

			Connections {
				target: tableView.selection
				onSelectionChanged: {
					context.model.clearSelection()
					tableView.selection.forEach( function(rowIndex) {
						context.model.addRowToSelection(rowIndex)
					} )
				}
			}

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

			Layout.fillWidth: true
			Layout.fillHeight: true
			
			property bool __completed: false
			
			QuickControls.TableViewColumn {
				title: "Severity"
				role: "severity"
			}

			QuickControls.TableViewColumn {
				title: "Type"
				role: "type"
			}
			
			QuickControls.TableViewColumn {
				title: "Text"
				role: "text"
			}

			itemDelegate: Misc.Text {
				text: styleData.value
				elide: Text.ElideRight
				color: {
					switch (styleData.column) {
						case 0: return severityColor(styleData.value)
						case 1: return _palette.color3
						case 2: return _palette.color2
					}
				}
				readonly property var padding: 5
				leftPadding: padding
				rightPadding: padding
				verticalAlignment: Text.AlignVCenter

				MouseArea {
					anchors.fill: parent
					acceptedButtons: Qt.RightButton
					hoverEnabled: true
					onClicked: menu.popupEx()

					ToolTip.delay: ControlsSettings.tooltipDelay
					ToolTip.timeout: ControlsSettings.tooltipTimeout
					ToolTip.visible: ToolTip.text.length != 0 && containsMouse
					ToolTip.text: text
				}
			}

			onModelChanged: {
				if (__completed)
					resizeColumnsToContents()
			}

			Component.onCompleted: {
				__completed = true
				resizeColumnsToContents()
			}
		}
	}
}