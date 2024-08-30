import QtQuick 2.7
import Controls 1.0 as TControls

import "..//Constants.js" as Constants

TControls.Menu {
	id: rootSubMenu

	property bool hidden: false

	modal: false
	focus: false

	readonly property var maxWidth: 150
	
	width: {
		var newWidth = 0
		for (var i = 0; i < count; ++i) {
			var currWidth = itemAt(i).width
			if (newWidth < currWidth)
				newWidth = currWidth
		}

		newWidth += leftPadding + rightPadding

		return newWidth > maxWidth ? maxWidth : newWidth
	}
}
