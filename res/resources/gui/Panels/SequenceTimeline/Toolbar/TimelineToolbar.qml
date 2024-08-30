import QtQuick 2.11
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "Bars"

ToolBar {
	id: root

	property alias treeAdapter: timelineBar.treeAdapter
	property alias curveActions: timelineBar.curveActions
	property alias curveView: sequenceBar.curveView

	implicitHeight: layout.implicitHeight + 5

	onActiveFocusChanged: {
		if(!activeFocus)
		{
			focus = false
		}
	}

	RowLayout {
		id: layout
		width: parent.width
		spacing: timelineSplitter.width

		SequenceBar {
			id: sequenceBar

			Layout.preferredWidth: timelineSplitter.x
			Layout.fillHeight: true
		}

		TimelineBar {
			id: timelineBar

			Layout.fillWidth: true
			Layout.fillHeight: true
		}
	}
}
