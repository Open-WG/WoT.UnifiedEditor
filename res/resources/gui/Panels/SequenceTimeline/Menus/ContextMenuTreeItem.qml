import QtQuick 2.11
import QtQuick.Layouts 1.4
import WGTools.AnimSequences 1.0
import WGTools.Controls 2.0

ContextMenuKeyBase {
	delegate: MenuItem {
		visible: !subMenu || !subMenu.hidden
	}

	MenuItem {
		text: "Normalize"
		visible: itemData && itemData.hasOwnProperty("hasNormalizeAbility") ? itemData.hasNormalizeAbility : false
		enabled: itemData && itemData.hasOwnProperty("canBeNormalized") ? itemData.canBeNormalized : false
		onTriggered: itemData.normalize()
	}

	MenuItem {
		text: "Group Selection"
		visible: itemData && itemData.itemType == SequenceItemTypes.Object
		onTriggered: context.groupSelectedNodes()
	}

	MenuItem {
		text: "Ungroup"
		visible: itemData && itemData.itemType == SequenceItemTypes.Group
		onTriggered: context.ungroupSelectedGroup()
	}

	ContextMenuTreeItemSubMenu {
		width: 65
		title: "Auto Calculate"
		hidden: itemData && itemData.hasOwnProperty("hasAutoCalculateAbility") ? !itemData.hasAutoCalculateAbility : true
		enabled: itemData && itemData.hasOwnProperty("canBeAutoCalculated") && itemData.canBeAutoCalculated

		MenuItem {
			text: "+Z"
			onTriggered: itemData.autoCalculate(Qt.vector3d(0, 0, 0))
		}

		MenuItem {
			text: "-Z"
			onTriggered: itemData.autoCalculate(Qt.vector3d(Math.PI, 0, 0))
		}

		MenuItem {
			text: "+Y"
			onTriggered: itemData.autoCalculate(Qt.vector3d(0, -Math.PI / 2, 0))
		}

		MenuItem {
			text: "-Y"
			onTriggered: itemData.autoCalculate(Qt.vector3d(0, Math.PI / 2, 0))
		}

		MenuItem {
			text: "+X"
			onTriggered: itemData.autoCalculate(Qt.vector3d(-Math.PI / 2, 0, 0))
		}

		MenuItem {
			text: "-X"
			onTriggered: itemData.autoCalculate(Qt.vector3d(Math.PI / 2, 0, 0))
		}
	}
}
