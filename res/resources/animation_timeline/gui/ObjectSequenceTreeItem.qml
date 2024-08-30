import QtQuick 2.7
import Controls 1.0
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

import "Buttons"
import "Constants.js" as Constants
import "Menus"

BaseSequenceTreeItem {
	id: objRoot

	TimelineButton {
		id: button
		width: 25
		height: parent.height

		enabled: popup.count != 0

		flat: true

		anchors.right: parent.right
		anchors.rightMargin: 8
		padding: 2
		
		iconImage: Constants.iconAddButton

		onClicked: popup.open()
	}

	Menu {
		id: popup

		x: parent.x
		y: parent.y + parent.height

		width: parent.width

		Repeater {
			id: rowRep

			model: itemDisplayData

			MenuItem {
				id: rootItem
				
				property var popupRef: popup
				property var _styleData: styleData

				width: parent.width

				contentItem: RowLayout {
					spacing: 8

					Image {
						id: icon

						Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
						Layout.leftMargin: rootItem.leftPadding

						source: popupIconPath
						sourceSize.width: Constants.seqTreeIconWidth
						sourceSize.height: Constants.seqTreeIconHeight
					}

					Text {
						text: popupLabel
						
						Layout.fillWidth: true
						Layout.alignment: Qt.AlignVCenter

						color: Constants.popupTextColor

						font.family: Constants.proximaRg
						font.pixelSize: Constants.fontSize
						font.bold: true
					}
				}

				onTriggered: {
					var type = itemDisplayData.itemClicked(index)
					if (type != -1)
					{	
						_styleData.addTrackSignHolder.testSign(type)
						rootItem.popupRef.close()
					}
				}
			}
		}
	}
}