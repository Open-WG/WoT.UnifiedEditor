import QtQuick 2.7
import Controls 1.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import "..//Constants.js" as Constants

Menu {
	id: rootMenu

	signal deletePressed()

	delegate: MenuItem { }

	MenuItem {
		id: deleteItem

		height: 25

		text: "Delete"
		
		onTriggered: {
			console.log(">>>>> del")
			deletePressed()
		}
	}
}