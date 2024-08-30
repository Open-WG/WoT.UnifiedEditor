import QtQuick 2.11
import WGTools.Controls 2.0
import Panels.SequenceTimeline 1.0

Menu {
	id: root

	property alias objectsModel: menuRepeater.model
	property var tableView

	MenuItem {
		text: "New Sequence"
		icon.source: Constants.iconNewSequence
		icon.color: "transparent"
		onClicked: context.createSequence()
	}

	MenuSeparator {
		height: visible ? implicitHeight : 0
		visible: menuRepeater.count > 0
	}

	Repeater {
		id: menuRepeater

		delegate: MenuItem {
			icon.source: model.popupData.icon
			icon.color: "transparent"
			text: model.popupData.label

			onTriggered: {
				root.objectsModel.triggered(index)
			}
		}
	}
}
