import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import WGTools.Controls 2.0 as Controls
import WGTools.Misc 1.0 as Misc

import "..//Constants.js" as Constants

Controls.MenuItem {
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

		Misc.Text {
			id: contentText

			Layout.fillWidth: true

			color: Constants.popupTextColor

			font.family: Constants.proximaRg
			font.bold: true
			font.pixelSize: 12
		}
	}
}
