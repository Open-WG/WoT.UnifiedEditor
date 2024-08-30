import QtQuick 2.10
import QtQml 2.2
import QtQml.Models 2.2

Item {
	id: root

	property var subgroups: []

	implicitWidth: p.totalWidth
	implicitHeight: blankDelegate.height

	Item {
		id: p

		property string ellipsis: "..."
		property int subgroupsCount: subgroups ? subgroups.length : 0
		property real totalWidth: 0
		property real lastWidth: 0
		property real ellipsisWidth: 0
		property real animDuration: 300
		property real animXOffset: 5

		visible: false
		enabled: false

		function init() {
			blankDelegate.modelData = ellipsis
			ellipsisWidth = blankDelegate.width
		}

		function update() {
			var newTotalWidth = 0

			if (subgroupsCount > 0)
			{
				for (var i = 0; i < subgroups.length; ++i)
				{
					blankDelegate.modelData = subgroups[i]
					newTotalWidth += blankDelegate.width

					if (i == subgroups.length-1)
					{
						lastWidth = blankDelegate.width
					}
				}
			}
			else
			{
				lastWidth = 0
			}

			totalWidth = newTotalWidth
			updateItems()
		}

		function updateItems() {
			var indices = []

			if (subgroupsCount == 0 || root.width < lastWidth)
			{
				// no
			}
			else if (root.width < (ellipsisWidth + lastWidth) || subgroupsCount == 1)
			{
				indices.push(subgroupsCount - 1)
			}
			else if (root.width < totalWidth)
			{
				indices.push("ellipsis")
				indices.push(subgroupsCount - 1)
			}
			else
			{
				for (var i = 0; i < subgroupsCount; ++i)
					indices.push(i)
			}

			showItems(indices)
		}

		function showItems(indices) {
			for (var i = 0; i < subgroupsCount; ++i)
			{
				var index = indices[i]
				var value = (index == "ellipsis") ? ellipsis : subgroups[index]

				if (i < listModel.count)
				{
					if (listModel.get(i).value != value)
					{
						listModel.insert(i, {value:value})
						listModel.remove(i+1)
					}
				}
				else
				{
					listModel.append({value:value})
				}
			}

			if (indices.length < listModel.count)
			{
				if (indices.length == 0)
				{
					listModel.clear()
				}
				else
				{
					listModel.remove(indices.length, listModel.count - indices.length)
				}
			}
		}

		Connections {
			target: root
			onWidthChanged: p.updateItems()
			onSubgroupsChanged: p.update()
			Component.onCompleted: p.init()
		}

		SubgroupBreadcrumbDelegate {
			id: blankDelegate
			property var modelData: p.ellipsis
		}
	}

	ListView {
		orientation: Qt.Horizontal
		interactive: false
		model: ListModel { id: listModel }
		delegate: SubgroupBreadcrumbDelegate {
			text: modelData
		}

		add: Transition {
			id: addTransition

			ParallelAnimation {
				NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: p.animDuration; easing.type: Easing.OutQuart }
				NumberAnimation { property: "x"; from: addTransition.ViewTransition.destination.x - p.animXOffset; duration: p.animDuration; easing.type: Easing.OutQuart }
			}
		}

		remove: Transition {
			id: removeTransition

			ParallelAnimation {
				NumberAnimation { property: "opacity"; to: 0; duration: p.animDuration; easing.type: Easing.OutQuart }
				NumberAnimation { property: "x"; to: removeTransition.ViewTransition.destination.x - p.animXOffset; duration: p.animDuration; easing.type: Easing.OutQuart }
			}
		}

		displaced: Transition {
	        NumberAnimation { property: "x"; duration: p.animDuration; easing.type: Easing.OutQuart }
	    }

		anchors.fill: parent
	}
}
