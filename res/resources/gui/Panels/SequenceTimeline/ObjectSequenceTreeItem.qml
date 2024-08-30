import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

import WGTools.Controls 2.0 as Controls
import WGTools.Misc 1.0 as Misc

import "Buttons"
import "Constants.js" as Constants
import "Menus"

BaseSequenceTreeItem {
	id: objRoot

	TimelineButton {
		id: addTrackButton
		Accessible.name: "+"
		width: 25
		height: parent.height

		enabled: itemData.availableTracksModel.hasItems
		hasHoveredState: false
		flat: true

		anchors.right: parent.right
		anchors.rightMargin: 8
		padding: 2
		
		iconImage: Constants.iconAddButton

		onClicked: {
			if (popup.visible)
				popup.close()
			else
				popup.openEx()
		}
	}

	TimelineButton {
		id: disableObjectButton
		Accessible.name: "disable"
		width: 25
		height: parent.height

		enabled: itemData.label != "Root"
		hasHoveredState: false
		flat: true

		anchors.right: addTrackButton.left
		anchors.rightMargin: 0
		padding: 2
		
		iconImage: itemData.seqObjEnabled ? Constants.openedEye : Constants.closedEye

		onClicked: {
			
			itemData.seqObjEnabled = !itemData.seqObjEnabled
		}
	}

	AddTrackMenu {
		id: popup

		x: parent.x
		y: parent.y + parent.height

		menuModel: itemData.availableTracksModel
	}
}
