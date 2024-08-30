import QtQuick 2.7
import "../Common"
import "../../Common/ActionBar"
import "../../../Settings.js" as Settings

MouseArea {
	id: header
	property alias text: title.text
	property alias actions: actionBar.actions

	height: Settings.group2HeaderHeight
	hoverEnabled: true
	onDoubleClicked: styleData.group.toggle()

	Rectangle {
		id: bg
		width: parent.width - x
		height: parent.height
		x: bgRound.x + bgRound.width / 2
		color: _palette.color7
	}

	Rectangle {
		id: bgRound
		height: parent.height
		width: height
		x: title.x - (width - title.indicator.width) / 2 + title.leftPadding
		radius: height / 2
		color: bg.color
	}

	GroupTitle {
		id: title

		readonly property real topHeadenHeight: Math.max(0, styleData.group.viewportTop - styleData.group.headerY)
		readonly property real bottomHeadenHeight: Math.max(0, styleData.group.headerHeight - (styleData.group.viewportBottom - styleData.group.headerY))
		readonly property real exposedHeight: Math.max(0, height - (topHeadenHeight + bottomHeadenHeight))

		x: Settings.titleIndent + (Settings.subTitleIndent * (styleData.group.depth - 1))
		opacity: height ? exposedHeight / height : 0
		enabled: opacity > 0.5
		expandingAnimationEnabled: styleData.group.expanding
		expanded: styleData.group.expanded
		onClicked: styleData.group.toggle()

		anchors.verticalCenter: parent.verticalCenter
	}

	ActionBar {
		id: actionBar
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		anchors.rightMargin: 10
	}
}
