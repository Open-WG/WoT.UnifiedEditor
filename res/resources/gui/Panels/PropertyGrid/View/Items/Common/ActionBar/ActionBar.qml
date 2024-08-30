import QtQuick 2.11
import WGTools.Controls.impl 1.0 as Impl
import "../../../Settings.js" as Settings

Row {
	property alias actions: repeater.model
	property var placeholderCount: 0

	spacing: 5

	Repeater {
		id: repeater
		
		ActionButton {
			implicitWidth: Settings.actionWidth
			action: Impl.ActionAdapter {
				action: modelData
				sourceScheme: "image://gui/"
			}
		}
	}

	// placeholder
	Item {
		implicitHeight: 10
		visible: parent.placeholderCount > 0

		implicitWidth: {
			var w = (parent.placeholderCount - repeater.count) * Settings.actionWidth
			if (repeater.count == 0) w += parent.spacing
			return w
		}
	}
}
