import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	component: Rectangle {
		width: parent.width
		implicitHeight: 30
		color: "green"

		border.width: 1
		border.color: "black"
	}

	properties: function(context) {
		console.log("Error: fallback delegate for type: [" + context.type + "]")
		return {}
	}
}
