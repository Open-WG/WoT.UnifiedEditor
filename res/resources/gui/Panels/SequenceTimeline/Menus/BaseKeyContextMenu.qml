import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import WGTools.Controls 2.0 as Controls

import "..//Constants.js" as Constants

Controls.Menu {
	id: rootMenu

	height: contentItem.implicitHeight + topPadding + bottomPadding
	delegate: Controls.MenuItem { }

	Controls.MenuItem {
		id: deleteItem

		text: "Delete"
		
		onTriggered: context.sequenceModel.deleteItems(context.selectionModel.selection)
	}
}