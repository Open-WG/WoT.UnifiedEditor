import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

Item {
	id: root

	property alias title: titleText.text
	property alias titleColumnWidth: titleText.width

	property var model
	property alias delegate: contentItemsPool.delegate

	property real rowHeight
	property real minRows: 2

	property real viewportTop: 0
	property real viewportHeight: 0

	property int currentIndex: -1
	readonly property int count: expandable ? (p.hintCount + 1) : p.hintCount

	readonly property alias expanded: p.expanded
	readonly property bool expandable: repeater.count >= minRows

	property real expandDuration: 0

	signal clicked(int index)

	implicitHeight: hintArea.height + (root.expandable ? expandingItem.height : 0)

	function expand(skipAnimation) {
		if (p.expanded)
			return

		if (skipAnimation === true)
		{
			p.expandAnimationEnabled = false
			p.expanded = true
			p.expandAnimationEnabled = true
		}
		else
		{
			p.expanded = true
		}
	}

	function collapse(skipAnimation) {
		if (!p.expanded)
			return

		if (skipAnimation === true)
		{
			p.expandAnimationEnabled = false
			p.expanded = false
			p.expandAnimationEnabled = true
		}
		else
		{
			p.expanded = false
		}
	}

	Keys.onReturnPressed: event.accepted = p.acceptEnterPressing()
	Keys.onEnterPressed: event.accepted = p.acceptEnterPressing()

	QtObject {
		id: p // private

		property bool expanded: false
		property bool expandAnimationEnabled: true
		readonly property int hintCount: expanded ? repeater.count : Math.min(minRows, repeater.count)
		readonly property int visibleHintCount: Math.ceil(hintArea.height / root.rowHeight)

		function toggleExpanded() {
			if (p.expanded)
				root.collapse()
			else
				root.expand()

			root.currentIndex = Qt.binding(function() { return p.visibleHintCount })
		}

		function acceptEnterPressing() {
			var accepted = false

			if (root.expandable && root.currentIndex == count-1)
			{
				toggleExpanded()
				accepted = true
			}
			else if (root.currentIndex !== -1)
			{
				clicked(root.currentIndex)
				accepted = true
			}

			return accepted
		}
	}

	ItemFactory {
		id: contentItemsPool
	}

	Item {
		id: hintArea
		width: parent.width
		height: p.hintCount * root.rowHeight
		clip: true

		Behavior on height {
			enabled: p.expandAnimationEnabled
			NumberAnimation { duration: root.expandDuration; easing.type: Easing.OutQuad }
		}

		Repeater {
			id: repeater
			model: root.delegate != null ? root.model : null
			delegate: HintItem {
				width: parent.width
				height: root.rowHeight
				y: root.rowHeight * index
				leftPadding: root.titleColumnWidth
				highlighted: index == root.currentIndex
				factory: contentItemsPool
				viewable: index != -1 &&
					(root.viewportTop - y) < height &&
					(y - root.viewportTop) < root.viewportHeight &&
					(y < hintArea.height)

				onClicked: {
					root.currentIndex = index
					root.clicked(index)
				}
			}
		}
	}

	ExpandingItem {
		id: expandingItem
		width: parent.width
		height: root.rowHeight
		leftMargin: root.titleColumnWidth
		y: hintArea.y + hintArea.height

		visible: root.expandable
		enabled: root.expandable
		selected: root.currentIndex == p.visibleHintCount

		expanded: p.expanded
		expandText: "Show more" + (root.title.length > 0 ? (" " + root.title.toLowerCase()) : "")
		collapseText: "Show less" + (root.title.length > 0 ? (" " + root.title.toLowerCase()) : "")

		onClicked: p.toggleExpanded()
	}

	Misc.Text {
		id: titleText
		verticalAlignment: Text.AlignVCenter
		height: root.rowHeight
		leftPadding: 10
		rightPadding: 10
		enabled: false

		// y: Math.min(Math.max(root.viewportTop, 0), hintArea.height - height)
	}
}
