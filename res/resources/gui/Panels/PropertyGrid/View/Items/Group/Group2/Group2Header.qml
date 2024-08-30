import QtQuick 2.7
import "../Common"
import "../../Common/ActionBar"
import "../../../Settings.js" as Settings

MouseArea {
	id: header
	property alias text: title.text
	property alias overridden: title.overridden
	property alias actions: actionBar.actions

	height: Settings.group2HeaderHeight
	hoverEnabled: true
	onDoubleClicked: styleData.group.toggle()

	HeaderShadow {
		source: bg
		anchors.fill: bg
	}

	Rectangle {
		id: bg
		width: parent.width
		height: parent.height
		x: title.x - (parent.height - title.indicator.width) / 2 + title.leftPadding
		color: _palette.color7
		radius: Settings.group2Round
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
