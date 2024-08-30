import QtQuick 2.10
import "../Common"
import "../../Common/ActionBar"
import "../../../Settings.js" as Settings
import WGTools.Controls.Details 2.0

MouseArea {
	property alias text: title.text
	property alias overridden: title.overridden
	property alias color: bg.color
	property alias actions: actionBar.actions

	height: Settings.group1HeaderHeight
	hoverEnabled: true
	onDoubleClicked: styleData.group.toggle()

	HeaderShadow {
		source: bg
		anchors.fill: bg
	}

	Rectangle {
		id: bg
		color: _palette.color7
		anchors.fill: parent
	}

	GroupTitle {
		id: title

		readonly property real topHeadenHeight: Math.max(0, styleData.group.viewportTop - styleData.group.headerY)
		readonly property real bottomHeadenHeight: Math.max(0, styleData.group.headerHeight - (styleData.group.viewportBottom - styleData.group.headerY))
		readonly property real exposedHeight: Math.max(0, height - (topHeadenHeight + bottomHeadenHeight))

		x: Settings.titleIndent
		opacity: height ? exposedHeight / height : 0
		enabled: opacity > 0.5
		expandingAnimationEnabled: styleData.group.expanding
		expanded: styleData.group.expanded
		onClicked: styleData.group.toggle()

		anchors.verticalCenter: parent.verticalCenter
	}

	SubgroupBreadcrumbs {
		id: subgroupBreadcrumbs
		subgroups: styleData.group.getGroupChainAt(styleData.group.viewportTop + styleData.group.childrenViewportOffset)
		visible: styleData.group.expanded && !styleData.group.expanding
		opacity: title.opacity

		anchors.left: title.right
		anchors.right: actionBar.left
		anchors.verticalCenter: parent.verticalCenter
	}

	ActionBar {
		id: actionBar
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		anchors.rightMargin: 10
	}
}
