import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import "..//Constants.js" as Constants
import "..//Debug"

MenuItem {
	id: root

	property alias iconPath: contentImage.source
	property alias label: contentText.text

	leftPadding: 10

	background: Rectangle {
		id: menuItem
		color: Constants.popupBackgroundColor

		Rectangle {
			id: frame

			anchors.fill: parent

			color: "transparent"
			border.color: "transparent"
			border.width: Constants.popupHoveredBorderWidth
		}

		MouseArea {
			hoverEnabled: true
			acceptedButtons: Qt.NoButton

			anchors.fill: parent

			onEntered: {
				frame.border.color = Constants.popupHoveredBorderColor
			}

			onExited: {
				frame.border.color = "transparent"
			}
		}
	}

	contentItem: RowLayout {
		spacing: 8
		anchors.fill: parent

		Image {
			id: contentImage

			Layout.leftMargin: root.leftPadding
			Layout.alignment: Qt.AlignLeft

			sourceSize.width: 16
			sourceSize.height: 16
		}

		Text {
			id: contentText

			Layout.fillWidth: true

			color: Constants.popupTextColor

			font.family: Constants.proximaRg
			font.bold: true
			font.pixelSize: 12
		}
	}
}
