import QtQuick 2.7
import QtQuick.Controls 2.0

import "Constants.js" as Constants
import SeqTreeItemTypes 1.0

BaseSequenceTreeItem {
	Text {
		function getStringValue(value) {
			if (typeof value == "number") {
				return Number(value).toLocaleString(Qt.locale("de_DE"), 'f', 3)
			}
			else {
				return value
			}
		}

		height: parent.height

		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
		anchors.rightMargin: 5
		
		verticalAlignment: Text.AlignVCenter

		color: Constants.toolbarTextColor

		text: itemDisplayData === undefined ? "" : getStringValue(itemDisplayData)

		font.family: Constants.proximaRg
		font.pixelSize: 12
		font.bold: true
	}
}