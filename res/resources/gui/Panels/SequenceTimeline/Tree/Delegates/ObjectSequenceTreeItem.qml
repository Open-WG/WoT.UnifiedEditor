import QtQuick 2.11
import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.Buttons 1.0
import Panels.SequenceTimeline.Menus 1.0

BaseSequenceTreeItem {
	Row {
		height: parent.height
		
		anchors.right: parent.right
		anchors.rightMargin: 15

		TimelineColorButton {
			color: context.colors.color(itemData.colorIndex)
			solid: itemData.colorSolid
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

		ActivatedTreeItemButton {
			Accessible.name: "disable"

			enabled: (itemData.label != "Root") && (!context.hasOwnProperty("soloItem") || !context.soloItem.valid)
			activatedIcon: itemData.isSound() ? Constants.soundEnabled : Constants.openedEye
			inactivatedIcon: itemData.isSound() ? Constants.soundDisabled : Constants.closedEye
			
			onActivatedChanged: itemData.seqObjActivated = activated
		}

		ActivatedTreeItemButton {
			Accessible.name: "solo"

			visible: context.hasOwnProperty("soloItem")
			enabled: visible && (itemData.label != "Root") && itemData.seqObjActivated
			activatedIcon: Constants.soloEnabled
			inactivatedIcon: Constants.soloDisabled

			onClicked: context.soloItem = (context.soloItem == styleData.index) ? null : styleData.index

			Binding on activated {
				value: context.soloItem == styleData.index
			}
		}

		TreeItemButton {
			Accessible.name: "+"

			enabled: itemData.availableTracksModel.hasItems
			iconImage: Constants.iconAddButton

			onClicked: {
				if (tracksMenu.visible)
					tracksMenu.close()
				else
					tracksMenu.openEx()
			}

			AddTrackMenu {
				id: tracksMenu
				y: parent.height
				menuModel: itemData.availableTracksModel
			}
		}
	}
}
