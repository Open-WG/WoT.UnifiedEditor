import QtQuick 2.11
import QtQuick.Controls 2.0
import WGTools.AnimSequences 1.0
import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.Buttons 1.0

BaseSequenceTreeItem {
	Row {
		height: parent.height
		
		anchors.right: parent.right
		anchors.rightMargin: 40

		ActivatedTreeItemButton {
			Accessible.name: "disable"

			enabled: (itemData.label != "Root") && !context.soloItem.valid
			activatedIcon: Constants.soundEnabled
			inactivatedIcon: Constants.soundDisabled
			
			onActivatedChanged: itemData.activated = activated
		}

		ActivatedTreeItemButton {
			Accessible.name: "solo"

			enabled: (itemData.label != "Root") && itemData.activated
			activatedIcon: Constants.soloEnabled
			inactivatedIcon: Constants.soloDisabled

			onClicked: context.soloItem = (context.soloItem == styleData.index) ? null : styleData.index

			Binding on activated {
				value: context.soloItem == styleData.index
			}
		}
	}
}
