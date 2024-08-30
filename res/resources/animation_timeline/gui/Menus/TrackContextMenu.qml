import QtQuick 2.7
import Controls 1.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import "..//Constants.js" as Constants

Menu {
	id: root

	signal addKeyPressed()

	MenuItem {
		height: 25

		text: "Add Key"

		font.family: Constants.proximaRg
		font.bold: true
		font.pixelSize: 12

		onTriggered: {
			addKeyPressed()
		}
	}
}
