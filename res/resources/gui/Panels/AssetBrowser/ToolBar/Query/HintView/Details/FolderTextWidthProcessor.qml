import QtQuick 2.7

QtObject {
	id: root

	property var items: []
	property int maxWidth: 0

	function addItem(item) {
		items.push(item)
		maxWidth = Math.max(maxWidth, item.folderTextWidth)
	}

	function removeItem(item) {
		var index = items.indexOf(item)
		if (index != -1)
		{
			items.splice(index, 1)

			if (item.folderTextWidth == maxWidth)
			{
				var newMaxWidth = 0
				items.forEach(function(item) { newMaxWidth = Math.max(newMaxWidth, item.folderTextWidth) })
				maxWidth = newMaxWidth
			}
		}
	}
}
