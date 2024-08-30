import QtQuick 2.10
import "../Common"
import "../../../Settings.js" as Settings
import WGTools.Controls.Details 2.0

MouseArea {
	property alias text: title.text
	property alias color: bg.color

	height: Settings.group1HeaderHeight
	hoverEnabled: true
	onDoubleClicked: styleData.group.toggle()

	Rectangle {
		id: bg
		color: _palette.color8
		anchors.fill: parent
	}

	Rectangle {
		implicitHeight: ControlsSettings.strokeWidth
		width: parent.width
		color: _palette.color5
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
		anchors.right: parent.right
		anchors.rightMargin: 10
		anchors.verticalCenter: parent.verticalCenter
	}
}
