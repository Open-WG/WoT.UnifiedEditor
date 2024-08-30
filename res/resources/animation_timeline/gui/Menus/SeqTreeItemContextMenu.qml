import QtQuick 2.7
import Controls 1.0
import QtQuick.Layouts 1.3

import Tracks 1.0
import "..//Constants.js" as Constants

Menu {
	id: treeItemContextMenu

	signal deleteTriggered()
	signal normalizePosDialogTriggered()

	property var modelData: null

	delegate: MenuItem {
		visible: !subMenu || !subMenu.hidden
	}

	MenuItem {
		id: root

		text: "Delete"

		onTriggered: {
			deleteTriggered()
		}
	}

	MenuItem {
		text: "Normalize"

		visible: modelData.itemTrack == Tracks.Position

		onTriggered: {
			normalizePosDialogTriggered()
		}
	}

	SeqTreeItemContextSubMenu {
		//width: parent.width

		title: "Auto Calculate"

		hidden: modelData.itemTrack != Tracks.Rotation
		enabled: modelData.itemCanAutoCalculate

		MenuItem {
			text: "+Z"

			onTriggered: {
				modelData.itemAutoCalculate = Qt.vector3d(0, 0, 0)
			}
		}

		MenuItem {
			text: "-Z"

			onTriggered: {
				modelData.itemAutoCalculate = Qt.vector3d(Math.PI, 0, 0)
			}
		}

		MenuItem {
			text: "+Y"

			onTriggered: {
				modelData.itemAutoCalculate = Qt.vector3d(0, -Math.PI / 2, 0)
			}
		}

		MenuItem {
			text: "-Y"

			onTriggered: {
				modelData.itemAutoCalculate = Qt.vector3d(0, Math.PI / 2, 0)
			}
		}

		MenuItem {
			text: "+X"

			onTriggered: {
				modelData.itemAutoCalculate = Qt.vector3d(-Math.PI / 2, 0, 0)
			}
		}

		MenuItem {
			text: "-X"

			onTriggered: {
				modelData.itemAutoCalculate = Qt.vector3d(Math.PI / 2, 0, 0)
			}
		}
	}
}