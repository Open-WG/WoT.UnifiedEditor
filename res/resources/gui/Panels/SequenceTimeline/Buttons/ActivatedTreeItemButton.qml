import QtQuick 2.11
import Panels.SequenceTimeline 1.0

TreeItemButton {

	property var activated: true
	property var activatedIcon: ""
	property var inactivatedIcon: ""

	iconImage: activated ? activatedIcon : inactivatedIcon

	onClicked: activated = !activated
}