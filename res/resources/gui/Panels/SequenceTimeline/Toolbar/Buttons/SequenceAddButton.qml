import QtQuick 2.11
import WGTools.Controls 2.0
import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.Menus 1.0

TimelineToolButton {
	iconImage: Constants.iconAddButton
	text: "Add"
	enabled: context.modelSelected

	ToolTip.text: "Add Sequence or Object"

	onClicked: {
		if (popup.visible)
			popup.close()
		else {
			popup.y = height
			popup.open()
		}
	}

	MenuAdd {
		id: popup
		objectsModel: context.seqObjectFactory && context.seqObjectFactory.availableObjects
	}
}
