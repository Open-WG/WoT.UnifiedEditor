import QtQuick 2.7
import "../Common"
import "../../../Settings.js" as Settings

MouseArea {
	property alias text: title.text

	height: Settings.group2HeaderHeight
	hoverEnabled: true
	onDoubleClicked: styleData.group.toggle()

	Rectangle {
		width: parent.height
		height: parent.width
		rotation: -90
		transformOrigin: Item.TopLeft
		y: parent.height
		color: _palette.color8
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
}
