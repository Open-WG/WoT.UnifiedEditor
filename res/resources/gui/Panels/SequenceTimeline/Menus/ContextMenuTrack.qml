import QtQuick 2.11
import WGTools.Controls 2.0

Menu {
	signal addKeyPressed()

	MenuItem {
		text: "Add Key"
		onTriggered: addKeyPressed()
	}
}
