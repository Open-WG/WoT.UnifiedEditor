import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQml.Models 2.11
import Panels.PropertyGrid.View 1.0 as View
import WGTools.PropertyGrid 1.0
import WGTools.Controls 2.0 as Controls
import WGTools.ControlsEx 1.0
import WGTools.Controls.Details 2.0 as Details
import WGTools.DialogsQml 1.0 as Dialogs
import WGTools.Views.Details 1.0 as Views
import WGTools.Misc 1.0 as Misc
import WGTools.Controls.impl 1.0

Rectangle {
	property var title: "Add Item"

	implicitWidth: 600
	implicitHeight: 500
	color: _palette.color8

	Accessible.name: title

	ListView {
		id: categories
		width: parent.width / 4
		height: parent.height
		anchors.top: parent.top
		anchors.bottom: footer.top
		clip: true
		model: context.categories

		Controls.ScrollBar.vertical: Controls.ScrollBar {}

		delegate: Views.RowDelegate {
			width: parent.width
			height: categoryLayout.implicitHeight + categoryLayout.anchors.topMargin + categoryLayout.anchors.bottomMargin

			readonly property QtObject styleData: QtObject {
				readonly property bool alternate: false
				readonly property bool selected: index == categories.currentIndex
				readonly property bool hasActiveFocus: false
				readonly property bool hovered: mac.containsMouse
			}

			MouseArea {
				id: mac
				hoverEnabled: true
				anchors.fill: parent
				onClicked: categories.currentIndex = index

				Binding on ActiveFocus.when {
					value: index == categories.currentIndex
					delayed: true
				}
			}

			RowLayout {
				id: categoryLayout
				anchors.margins: 6
				anchors.fill: parent

				Misc.IconLabel {
					spacing: 5

					label.text: model.display? model.display : "All"

					icon.source: ""
					Layout.fillWidth: true
				}
			}
		}

		onCurrentIndexChanged: context.selectCategory(categories.currentIndex)
	}
	
	ListView {
		id: items
		height: parent.height
		anchors {
			left: categories.right
			right: parent.right
			top: parent.top
			bottom: footer.top
		}
		clip: true
		highlightFollowsCurrentItem: false
		model: context.items

		Controls.ScrollBar.vertical: Controls.ScrollBar {}

		delegate: Views.RowDelegate {
			width: parent.width
			height: layout.implicitHeight + layout.anchors.topMargin + layout.anchors.bottomMargin

			readonly property QtObject styleData: QtObject {
				readonly property bool alternate: false
				readonly property bool selected: index == items.currentIndex
				readonly property bool hasActiveFocus: false
				readonly property bool hovered: mouseArea.containsMouse
			}

			MouseArea {
				id: mouseArea
				anchors.fill: parent
				hoverEnabled: true
				onClicked: items.currentIndex = index
				onDoubleClicked: {
					if (mouse.button == Qt.LeftButton) {
						context.add()
					}
				}
			}

			RowLayout {
				id: layout
				anchors.margins: 6
				anchors.fill: parent

				Misc.IconLabel {
					spacing: 10
					label.text: model.name ? model.name : ""
					icon.source: model && model.icon ? "image://gui/" + model.icon : ""
					Layout.fillWidth: true
				}
			}
		}

		onCurrentIndexChanged: context.selectComponent(items.currentIndex)
	}

	Item {
		id: footer
		width: parent.width
		height: buttons.height

		anchors.bottom: parent.bottom

		Rectangle {// separator
			width: parent.width; height: 1
			color: _palette.color9
		}

		Row {
			id: buttons
			anchors.right: parent.right
			spacing: 5
			padding: spacing

			SearchField {
				id: filterTextField
				placeholderText: "Filter"
				text: context.items.filterText

				Binding {
					target: context.items
					property: "filterText"
					value: filterTextField.text
				}
			}

			Controls.Button {
				implicitWidth: ControlsSettings.width
				text: "Cancel"
				onClicked: context.cancel()
			}

			Controls.Button {
				implicitWidth: ControlsSettings.width
				text: "Add"
				onClicked: context.add()
			}

			Controls.Button {
				implicitWidth: ControlsSettings.width
				text: "Reload Library"
				onClicked: context.reload()
			}
		}
	}
}
