import QtQuick 2.11
import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.Buttons 1.0
import Panels.SequenceTimeline.Menus 1.0

BaseSequenceTreeItem {
	Row {
		height: parent.height
		
		anchors.right: parent.right
		anchors.rightMargin: 15

		// uncomment when group will have its own bar (https://jira.wargaming.net/browse/WOTD-175401)
		/*
		TimelineColorButton {
			color: context.colors.color(itemData.colorIndex)
			onClicked: colorMenuLoader.active = true

			anchors.verticalCenter: parent.verticalCenter

			Loader {
				id: colorMenuLoader
				active: false
				onLoaded: item.openEx()

				sourceComponent: MenuColor {
					colorIndex: itemData.colorIndex
					onTriggered: itemData.colorIndex = index
					onClosed: colorMenuLoader.active = false
				}
			}
		}
		*/

		TimelineButton {
			Accessible.name: "disable"
			anchors.verticalCenter: parent.verticalCenter

			width: 25
			height: parent.height
			padding: 2

			//enabled: (itemData.label != "Root") && (context.soloItem == -1)
			hasHoveredState: false
			flat: true

			iconImage: itemData.seqObjActivated ? Constants.openedEye : Constants.closedEye

			onClicked: {
				itemData.seqObjActivated = !itemData.seqObjActivated
			}
		}
	}
}
