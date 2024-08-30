import QtQuick 2.10
import QtQml.Models 2.2
import WGTools.Controls.impl 1.0
import WGTools.Shapes 1.0 as Shapes

ToolButton {
	id: control
	property alias model: delegateModel.model
	property int currentIndex: 0
	signal longPress()

	icon.source: menu != null && menu.count != 0 ? menu.itemAt(currentIndex).icon.source : ""

	onClicked: {
		menu.itemAt(currentIndex).execute()
	}

	ToolTip.text: menu != null && menu.count != 0 ? menu.itemAt(currentIndex).text : ""

	onLongPress: {
		menu.openEx()
	}

	Component.onCompleted: updateIndex()

	Shapes.Triangle {
		width: 6
		height: 3
		rotation: -45
		color: _palette.color2
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 2

		MouseArea {
			anchors.fill: parent
			onClicked: menu.openEx()
		}
	}

	DelegateModel {
		id: delegateModel
		rootIndex: index != -1 ? modelIndex(index) : -1
		delegate: MenuItem {
			enabled: model.type != "Separator"

			icon.source: model.action != null && theAction.icon.source != theAction.sourceScheme ? theAction.icon.source : ""
			text: model.action != null ? theAction.text : ""
			checkable: true
			checked: model.action != null ? theAction.checked : false

			onCheckedChanged: {
				updateIndex()
			}

			function execute() {
				theAction.trigger()
			}

			onTriggered: {
				theAction.trigger()
			}

			ActionAdapter {
				id: theAction
				action: model.action
				sourceScheme: "image://gui/"
			}

			MenuSeparator {
				visible: model.type == "Separator"
			}
		}
	}

	Menu {
		id: menu
		y: parent.height

		Repeater {
			model: delegateModel
		}
	}

	Timer {
		interval: 200
		running: control.pressed
		onTriggered: control.longPress()
	}

	function updateIndex() {
		for (var i = 0; i < menu.count; ++i) {
			if (menu.itemAt(i).checked) {
				checked = true
				currentIndex = i
				return
			}
		}
		checked = false
	}
}
