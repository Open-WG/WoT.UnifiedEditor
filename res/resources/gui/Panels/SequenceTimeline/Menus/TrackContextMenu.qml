import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import WGTools.Controls 2.0 as Controls

import "..//Constants.js" as Constants

Controls.Menu {
	id: root

	height: contentItem.implicitHeight + topPadding + bottomPadding
	signal addKeyPressed()

	Controls.MenuItem {
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
