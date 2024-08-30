import QtQuick 2.11
import QtQuick.Controls 1.4 as QuickControls
import QtQuick.Layouts 1.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Misc 1.0 as Misc
import WGTools.Views 1.0
import QtQml.Models 2.11

ControlsEx.Panel {
	id: modelValidator
	title: "Validator"
	layoutHint: "bottom"
	
	function selectAllNodes(parentIndex) {
		for(var i = 0; i < context.model.rowCount(parentIndex); i++) {
			var index = context.model.index(i, 0, parentIndex)
			treeView.selection.select(index, ItemSelectionModel.Select)
			selectAllNodes(index)
		}
	}

	function severityColor(severity) {
		switch (severity)
		{
		case 0: return _palette.color2
		case 1: return _palette.color16
		case 2: return _palette.color15
		case 3: return _palette.color14
		default: return _palette.color2
		}
	}

	Rectangle {
		width: animation.width;
		height: animation.height;
		color: _palette.color7
		visible: !context.disabled && context.inProgress

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

	Rectangle {
		width: image.width
		height: image.height
		color: _palette.color8
		visible: context.disabled

		Image {
			id: image

			width: sourceSize.width * 0.75
			height: sourceSize.width * 0.75

			source: "image://gui/no-select-2"
		}

		Text {
			text: "Validation is disabled, because current realm is not 'DEV'"
			anchors.top: image.bottom
			anchors.topMargin: 5
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
		visible: (!context.disabled && !context.inProgress && context.model.rowCount() == 0)
	}

	ColumnLayout {
		anchors.fill: parent 
		spacing: 2
		visible: (!context.disabled && !context.inProgress && context.model.rowCount() > 0)

		TreeView {
			id: treeView
			model: context.model
			headerVisible: false
			selectionMode: QuickControls.SelectionMode.ExtendedSelection 
			selection: context.selectionModel

			Menu {
				id: menu

				Action {
					text: "&Copy"
					shortcut: StandardKey.Copy
					onTriggered: context.model.copySelected(treeView.selection.selectedIndexes)
				}

				Action {
					text: "Select All"
					shortcut: StandardKey.SelectAll
					onTriggered: selectAllNodes()
				}
			}

			Layout.fillWidth: true
			Layout.fillHeight: true
			
			property bool __completed: false
			 
			QuickControls.TableViewColumn {
				title: ""
				role: "DisplayRole"
			}

			itemDelegate: Misc.Text {
				text: styleData.value
				elide: Text.ElideRight
				color: {
					switch (styleData.column) {
						case 0: return severityColor(context.model.getNodeSeverity(styleData.index))
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

			onDoubleClicked: {
				treeView.toggleExpanded(treeView.currentIndex)
				context.model.onDoubleClicked(treeView.currentIndex)
			}

			Component.onCompleted: {
				__completed = true
				resizeColumnsToContents()
			}
		}
	}
}