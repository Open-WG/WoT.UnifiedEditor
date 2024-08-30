import QtQuick 2.7
import QtQuick.Layouts 1.3

import WGTools.AnimSequences 1.0 as Sequences
import WGTools.Controls 2.0 as Controls

import "..//Constants.js" as Constants

Controls.Menu {
	id: treeItemContextMenu

	signal deleteTriggered()
	signal normalizePosDialogTriggered()

	height: contentItem.implicitHeight + topPadding + bottomPadding
	delegate: Controls.MenuItem {
		visible: !subMenu || !subMenu.hidden
	}

	Controls.MenuItem {
		id: root

		text: "Delete"

		onTriggered: {
			deleteTriggered()
		}
	}

	Controls.MenuItem {
		text: "Normalize"

		visible: itemData && itemData.hasOwnProperty("hasNormalizeAbility") ? itemData.hasNormalizeAbility : false
		enabled: itemData && itemData.hasOwnProperty("canBeNormalized") ? itemData.canBeNormalized : false

		onTriggered: {
			normalizePosDialogTriggered()
		}
	}

	SeqTreeItemContextSubMenu {
		title: "Auto Calculate"
		width: 65
		hidden: itemData && itemData.hasOwnProperty("hasAutoCalculateAbility")
			? !itemData.hasAutoCalculateAbility : true
		enabled: itemData && itemData.hasOwnProperty("canBeAutoCalculated")
			? itemData.canBeAutoCalculated : false

		Controls.MenuItem {
			text: "+Z"

			onTriggered: itemData.autoCalculate(Qt.vector3d(0, 0, 0))
		}

		Controls.MenuItem {
			text: "-Z"

			onTriggered: itemData.autoCalculate(Qt.vector3d(Math.PI, 0, 0))
		}

		Controls.MenuItem {
			text: "+Y"

			onTriggered: itemData.autoCalculate(Qt.vector3d(0, -Math.PI / 2, 0))
		}

		Controls.MenuItem {
			text: "-Y"

			onTriggered: itemData.autoCalculate(Qt.vector3d(0, Math.PI / 2, 0))
		}

		Controls.MenuItem {
			text: "+X"

			onTriggered: itemData.autoCalculate(Qt.vector3d(-Math.PI / 2, 0, 0))
		}

		Controls.MenuItem {
			text: "-X"

			onTriggered: itemData.autoCalculate(Qt.vector3d(Math.PI / 2, 0, 0))
		}
	}
}
