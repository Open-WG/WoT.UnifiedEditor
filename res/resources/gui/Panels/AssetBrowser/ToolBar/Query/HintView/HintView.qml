import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Views.Details 1.0
import "Details" as Details
import "Delegates" as Delegates

Rectangle {
	id: root

	property var models: []
	property var delegates
	property alias headerDelegate: headerLoader.sourceComponent

	property int currentIndex: -1
	readonly property alias count: p.totalRowCount

	property real rowHeight: ViewsSettings.rowDelegateHeight
	property real titleColumnWidth: 70

	property int minRowsPerGroup: 2

	signal hintClicked(string modelId, int index)
	signal headerClicked()

	color: _palette.color5

	onCurrentIndexChanged: {
		p.syncChildSelection()
		p.updateKeysForward()
	}

	Keys.onUpPressed: {
		currentIndex = (currentIndex > 0) ? currentIndex - 1 : count - 1
		event.accepted = true
	}

	Keys.onDownPressed: {
		currentIndex = (currentIndex < count-1) ? currentIndex + 1 : 0
		event.accepted = true
	}

	Keys.onReturnPressed: event.accepted = p.acceptEnterPressing()
	Keys.onEnterPressed: event.accepted = p.acceptEnterPressing()

	QtObject {
		id: p // private

		property bool headerVisible: root.headerDelegate !== null
		property bool currentIndexSyncing: false
		
		property var groups: []
		property int totalRowCount: headerVisible ? 1 : 0

		function addGroup(index, group) {
			groups.splice(index, 0, group)
			updateTotalRowCount()
		}

		function removeGroup(index) {
			totalRowCount -= groups[index].count
			groups.splice(index, 1)

			updateTotalRowCount()
		}

		function updateTotalRowCount() {
			var count = headerVisible ? 1 : 0

			groups.forEach(function(group) {
				count += group.count
			})

			totalRowCount = count
		}

		function syncChildSelection() {
			if (currentIndexSyncing)
				return

			currentIndexSyncing = true

			var res = findGroup(root.currentIndex)

			if (res !== null)
				res.group.currentIndex = root.currentIndex - res.offset

			groups.forEach(function(group) {
				if (res === null || res.group != group)
				{
					group.currentIndex = -1
				}
			})

			currentIndexSyncing = false
		}

		function syncRootSelection(group) {
			if (currentIndexSyncing)
				return

			currentIndexSyncing = true

			var index = -1
			var offset = headerVisible ? 1 : 0
			var targetProcessed = false

			groups.forEach(function(theGroup) {
				if (theGroup == group)
				{
					index = offset + theGroup.currentIndex
					targetProcessed = true
				}
				else
				{
					if (!targetProcessed)
					{
						offset += theGroup.count
					}
					
					theGroup.currentIndex = -1
				}
			})

			root.currentIndex = index
			currentIndexSyncing = false
		}

		function updateKeysForward() {
			var res = findGroup(root.currentIndex)

			if (res !== null)
			{
				root.Keys.forwardTo = res.group
			}
			else
			{
				root.Keys.forwardTo = null
			}
		}

		function findGroup(rootIndex) {
			var offset = headerVisible ? 1 : 0

			for (var i = 0; i < groups.length; ++i)
			{
				var group = groups[i]

				if (root.currentIndex >= offset &&
					root.currentIndex < (offset + group.count))
				{
					return {group: group, offset: offset}
				}
				else
				{
					offset += group.count
				}
			}

			return null
		}

		function acceptEnterPressing() {
			var accepted = false

			if (root.currentIndex == 0)
			{
				root.headerClicked()
				accepted = true
			}

			return accepted
		}

		onHeaderVisibleChanged: {
			updateTotalRowCount()
		}
	}

	Flickable {
		id: flickable
		contentHeight: column.height

		anchors.fill: parent

		ScrollBar.vertical: ScrollBar {}

		Column {
			id: column
			width: parent.width
			spacing: 10

			Details.RowItem {
				id: headerItem
				width: parent.width
				height: root.rowHeight
				selected: root.currentIndex == 0
				visible: p.headerVisible
				enabled: p.headerVisible

				onClicked: {
					root.currentIndex = 0
					root.headerClicked()
				}

				Loader {
					id: headerLoader

					anchors.fill: parent
					anchors.leftMargin: root.titleColumnWidth
				}
			}

			Repeater {
				model: root.models

				delegate: Details.HintGroup {
					id: hintGroup

					readonly property int groupIndex: index

					width: parent !== null ? parent.width : implicitWidth
					rowHeight: root.rowHeight

					viewportTop: flickable.contentY - y
					viewportHeight: flickable.height

					visible: count > 0
					enabled: visible

					model: (typeof modelData.model !== "undefined") ? modelData.model : null
					delegate: {
						var modelName = (typeof modelData.name !== "undefined") ? modelData.name : null

						if (modelName !== null)
						{
							switch (typeof root.delegates)
							{
							case "string":
								break;

							case "object":
								if (typeof root.delegates[modelName] !== "undefined")
								{
									return root.delegates[modelName]
								}
								break;
							}
						}

						return defaultHintDelegate
					}

					title: (typeof modelData.title !== "undefined") ? modelData.title : ""
					titleColumnWidth: root.titleColumnWidth
					expandDuration: 250

					onCountChanged: {
						p.updateTotalRowCount()
					}

					onCurrentIndexChanged: {
						p.syncRootSelection(hintGroup)
					}

					onClicked: {
						var modelId = (typeof modelData.name !== "undefined") ? modelData.name : hintGroup.groupIndex
						root.hintClicked(modelId, index)
					}

					Component {
						id: defaultHintDelegate // fallback delegate
						Delegates.DefaultHintDelegate {}
					}
				}

				onItemAdded: p.addGroup(index, item)
				onItemRemoved: p.removeGroup(index)
			}
		}
	}
}
