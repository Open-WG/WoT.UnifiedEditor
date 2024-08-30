import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Debug 1.0
import "../../../Settings.js" as Settings

Control {
	id: control

	property Item label
	property Item item

	readonly property alias splitter: splitter

	property real hSpacing: 5
	property real vSpacing: 0

	property int orientation: Qt.Horizontal
	readonly property bool horizontal: orientation == Qt.Horizontal

	property bool active: false
	property bool selected: false
	property bool gridMember: model && model.node.gridMember

	topPadding: Settings.propertyVerticalPadding
	bottomPadding: Settings.propertyVerticalPadding
	leftPadding: Settings.propertyLeftPadding
	rightPadding: Settings.propertyRightPadding
	spacing: horizontal ? hSpacing : vSpacing
	hoverEnabled: true
	focus: true

	contentItem: PGRowContent {}
	background: PGRowBackground {}

	onActiveChanged: {
		if (!active) {
			focus = true
		}
	}

	Keys.onEscapePressed: {
		if (focus) {
			event.accepted = false
		} else {
			focus = true
			event.accepted = true
		}
	}
	Keys.onTabPressed: Keys.enterPressed(event)
	Keys.onReturnPressed: Keys.enterPressed(event)
	Keys.onEnterPressed: {
		if (focus) {
			let nextItem = nextItemInFocusChain(true)
			if (nextItem) {
				nextItem.forceActiveFocus(Qt.TabFocusReason)
			}
		} else {
			focus = true
		}
	}

	PGRowSplitter {
		id: splitter
		x: control.leftPadding + (control.label ? (splitter.enabled ? control.label.width : control.label.implicitWidth) : 0)
	}
}
