import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.ControlsEx.Details 1.0

Control {
	id: control

	default property alias buttons: ci.buttons

	property bool collapsable: true

	padding: 2
	hoverEnabled: true
	clip: true

	resources: [
		QtObject {
			id: internal

			readonly property bool hovered: {
				if (!control.collapsable)
					return true

				if (control.hovered)
					return true

				for (var i=0; i < control.buttons.length; ++i) {
					var button = control.buttons[i]
					if (button.rowData && button.rowData.hovered)
						return true
				}

				return false
			}
		}
	]

	contentItem: CollapsableRowContentItem {
		id: ci
		state: internal.hovered ? "expanded" : ""
	}

	background: CollapsableRowBackground {
		state: internal.hovered ? "expanded" : ""

		expaned.color: "blue"
	}
}
