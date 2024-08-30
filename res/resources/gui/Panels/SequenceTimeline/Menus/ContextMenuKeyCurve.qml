import QtQuick 2.11
import QtQml 2.11
import WGTools.Controls 2.0

ContextMenuKeyBase {
	MenuSeparator {}

	MenuItem { action: curveActions.action("smoothTangent") }
	MenuItem { action: curveActions.action("linearTangent") }
	MenuItem { action: curveActions.action("steppedTangent") }
	MenuItem { action: curveActions.action("freeTangent") }
	MenuItem { action: curveActions.action("brokenTangent") }

	MenuSeparator {}

	Menu {
		modal: false
		title: "In Tangent"

		MenuItem { action: curveActions.action("smoothInTangent"); visible: false }
		MenuItem { action: curveActions.action("freeInTangent") }
		MenuItem { action: curveActions.action("linearInTangent") }
		MenuItem { action: curveActions.action("steppedInTangent") }
	}

	MenuSeparator {}

	Menu {
		modal: false
		title: "Out Tangent"

		MenuItem { action: curveActions.action("smoothOutTangent"); visible: false }
		MenuItem { action: curveActions.action("freeOutTangent") }
		MenuItem { action: curveActions.action("linearOutTangent") }
		MenuItem { action: curveActions.action("steppedOutTangent") }
	}
	
	MenuItemKeyAddComment {}
}
