import QtQuick 2.7
import QtQml.Models 2.11
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import WGTools.Controls 2.0 as Controls

import "..//Constants.js" as Constants

Controls.Menu {
	id: root

	property alias model: menuRepeater.model

	height: contentItem.implicitHeight + topPadding + bottomPadding
	delegate: AddSeqObjectPopupEntry {}

	Repeater {
		model: DelegateModel {
			id: menuRepeater

			delegate: AddSeqObjectPopupEntry {
				height: 30
				width: root.width

				iconPath: model.popupData.icon
				label: model.popupData.label

				onTriggered: {
					root.model.triggered(menuRepeater.modelIndex(index))
				}
			}
		}
	}
}
