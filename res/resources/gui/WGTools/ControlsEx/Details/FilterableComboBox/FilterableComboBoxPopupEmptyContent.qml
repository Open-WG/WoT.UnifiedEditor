import QtQuick 2.11
import WGTools.Controls 2.0

ItemDelegate {
	text: "No results for " + control.contentItem.text
	background: Rectangle {
		color: "transparent"
	}
}
