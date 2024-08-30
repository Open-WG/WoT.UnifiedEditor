import QtQuick 2.10
import QtQuick.Window 2.3
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import "ChannelButtons"
import "BGButton"
import "BGMenu"

Menu {
	property alias channelCount: channelButtons.channelCount
	property alias settings: channelButtons.settings

	ChannelButtons {
		id: channelButtons
		width: Math.min(implicitWidth, parent.width)
	}

	MenuSeparator {
	}

	BGMenu {
		id: bgMenu
		Accessible.name: "Background"
		settings: channelButtons.channelCount > 3 ? channelButtons.settings : null
	}

	MenuSeparator {
	}

	MenuItem {
		text: "Edit image in new tab"
		onTriggered: context.openImageEditor(propertyData.value)
	}

	MenuItem {
		text: "Reset property"
		onTriggered: propertyData.setValue("")
		enabled: delegateRoot.__enabled
	}

	MenuSeparator {
	}

	MenuItem {
		text: "System Menu"
		onTriggered: context.openSystemMenu(propertyData.value)
	}
}
