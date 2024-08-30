import QtQuick 2.11
import QtQuick.Layouts 1.3

import WGTools.Controls 2.0
import WGTools.Misc 1.0 as Misc

import "..//Constants.js" as Constants

Menu {
	id: submenu

	property var menuModel: null
	property var rootIndex: null

	delegate: MenuItem {
		id: item

		contentItem: RowLayout {
			spacing: 8

			Image {
				id: image

				Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
				source: "image://gui/animation_sequence/tracks/custom"
				sourceSize.width: Constants.seqTreeIconWidth
				sourceSize.height: Constants.seqTreeIconHeight
			}

			Misc.Text {
				text: item.text
				
				Layout.fillWidth: true
				Layout.alignment: Qt.AlignVCenter

				color: Constants.popupTextColor

				font.family: Constants.proximaRg
				font.pixelSize: Constants.fontSize
				font.bold: true
			}
		}
	}

	AddTrackSubMenu {
		id: trackSubMenu

		menu: submenu
		menuModel: submenu.menuModel
		rootIndex: submenu.rootIndex
	}
}
