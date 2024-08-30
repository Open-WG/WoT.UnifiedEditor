import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import WGTools.Views 1.0 as Views
import WGTools.Views.Details 1.0 as ViewDetails
import WGTools.Views.Styles 1.0 as ViewStyles
import WGTools.Controls 2.0 as Controls
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Misc 1.0 as Misc
import WGTools.Debug 1.0 as Debug
import WGTools.FilesystemQuickFilters 1.0
import "Details" as Details

ColumnLayout {
	property alias filesystemSelection: filesystemTree.selection
	spacing: 0

	RowLayout {
		Layout.preferredHeight: 30
		Layout.fillWidth: true
		Layout.alignment: Qt.AlignRight
		Layout.rightMargin: 10

		Controls.CheckBox {
			id: testCon
			text: "Online"

			checked: context.filesystemController.isOnline

			onClicked: {
				context.filesystemController.isOnline = checked
			}
		}

		ControlsEx.SearchField {
			Layout.fillWidth: true

			placeholderText: "Filter"
			enabled: context.filesystemController.isOnline

			onTriggered: {
				context.filesystemController.filesystemModel.setFilterFixedString(text)
			}
		}

		Controls.Button {
			text: "Select All"
			enabled: context.filesystemController.isOnline

			Layout.alignment: Qt.AlignLeft

			onClicked: context.filesystemController.toggleAllFilesSelection(true)
		}

		Controls.Button {
			text: "Deselect All"
			enabled: context.filesystemController.isOnline

			Layout.alignment: Qt.AlignLeft

			onClicked: context.filesystemController.toggleAllFilesSelection(false)
		}
	}

	RowLayout {
		Layout.preferredHeight: 30
		Layout.fillWidth: true
		Layout.alignment: Qt.AlignRight
		Layout.rightMargin: 10

		enabled: context.filesystemController.isOnline

		Controls.RadioButton {
			text: "All"
			checked: true
			Layout.alignment: Qt.AlignLeft
			Layout.fillWidth: true
			onClicked: context.filesystemController.filesystemQuickFilterModel
				.setQuickFilter(FilesystemQuickFilters.NO_FILTER)
		}

		Controls.RadioButton {
			text: "Chunks"

			Layout.alignment: Qt.AlignLeft
			Layout.fillWidth: true

			onClicked: context.filesystemController.filesystemQuickFilterModel
				.setQuickFilter(FilesystemQuickFilters.CHUNKS)
		}

		Controls.RadioButton {
			text: "Global Chunk"

			Layout.alignment: Qt.AlignLeft
			Layout.fillWidth: true

			onClicked: context.filesystemController.filesystemQuickFilterModel
				.setQuickFilter(FilesystemQuickFilters.GLOBAL_CHUNK)
		}

		Controls.RadioButton {
			text: "Roads"

			Layout.alignment: Qt.AlignLeft
			Layout.fillWidth: true

			onClicked: context.filesystemController.filesystemQuickFilterModel
				.setQuickFilter(FilesystemQuickFilters.ROADS)
		}

		Controls.RadioButton {
			text: "Environment"

			Layout.alignment: Qt.AlignLeft
			Layout.fillWidth: true

			onClicked: context.filesystemController.filesystemQuickFilterModel
				.setQuickFilter(FilesystemQuickFilters.ENVIRONMENT)
		}

		Controls.RadioButton {
			text: "Camera Effects"

			Layout.alignment: Qt.AlignLeft
			Layout.fillWidth: true
			
			onClicked: context.filesystemController.filesystemQuickFilterModel
				.setQuickFilter(FilesystemQuickFilters.CAMERA_EFFECTS)
		}
	}

	Rectangle {
		Layout.fillWidth: true
		Layout.preferredHeight: 1
		color: _palette.color8
	}

	Item {
		Layout.fillWidth: true
		Layout.fillHeight: true

		Views.TreeView {
			id: filesystemTree
			visible: context.filesystemController.isOnline
			headerVisible: true
			selectionMode: SelectionMode.ExtendedSelection
			model: context.filesystemController.filesystemModel

			anchors.fill: parent

			style: ViewStyles.TreeViewStyle {
				rowDelegate: Details.FileSystemRowDelegate {
				}
			}

			Keys.onPressed: {
				if (event.modifiers & Qt.ControlModifier )
				{
					if (event.key == Qt.Key_A)
						context.filesystemController.toggleAllFilesSelection(true)
					else if (event.key == Qt.Key_D)
						context.filesystemController.toggleAllFilesSelection(false)
				}
			}

			onDoubleClicked: {
				//if we do not set this to false, internal qt logic will reselect
				// on release
				filesystemTree.__mouseArea.selectOnRelease = false
				context.filesystemController.selectWholeFolder(index)
			}

			TableViewColumn {
				id: nameColumn

				title: "Name"
				resizable: true

				delegate: Controls.Control {
					Controls.ToolTip.text: fileName.text
					Controls.ToolTip.visible: hovered && fileName.truncated
					hoverEnabled: true

					contentItem: Row {
						spacing: 8
						Layout.alignment: Qt.AlignLeft
						Image {
							id: image
							anchors.verticalCenter: parent.verticalCenter
							source: "image://systemIcon/" + (model ? model.fileIcon : "")
							cache: false
							smooth: true
							fillMode: Image.Pad

							Connections {
								target: styleData
								ignoreUnknownSignals: true
								onValueChanged: {
									image.source = ""
									if (model)
										image.source = "image://systemIcon/" + (model ? model.fileIcon : "")
								}
							}
						}
						Misc.Text {
							id: fileName
							anchors.verticalCenter: parent.verticalCenter
							width: parent.width - x
							horizontalAlignment: styleData.textAlignment
							text: model ? (model.displayName ? model.displayName : model.fileName) : ""
							elide: styleData.elideMode
							color: _palette.color2
						}
					}
				}

				onWidthChanged: {
					width = Math.max(width, 100)
				}
			}

			TableViewColumn {
				title: "Locked By"
				role: "lockedBy"
				resizable: true
			}

			TableViewColumn {
				title: "Lock Date"
				role: "lockDate"
				resizable: true
			}

			TableViewColumn {
				title: "Message"
				role: "commitMessage"
			}

			Connections {
				target: filesystemTree.selection
				onSelectionChanged: {
					if (selected.length != 0)
						filesystemTree.positionViewAtIndex(
							selected[selected.length - 1].bottomRight, ListView.Contain)
				}
			}
		}

		OfflinePanel {
			visible: !context.filesystemController.isOnline

			anchors.fill: parent
		}
	}

	Controls.CheckBox {
		text: "Load only locked chunks"

		checked: context.filesystemController.checkOnLoad

		onClicked: {
			context.filesystemController.checkOnLoad = checked
		}
	}
}
