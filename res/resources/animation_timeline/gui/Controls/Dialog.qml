import QtQuick 2.10
import QtQuick.Controls 2.3

import "..//Buttons"
import "..//Constants.js" as Constants
import "..//Debug"

Dialog {
	id: control

	padding: 0

	header: Label {
		x: 1
		y: 1

		text: control.title
		visible: control.title
		elide: Label.ElideRight

		padding: 4

		font.family: Constants.proximaRg
		font.bold: true
		font.pixelSize: 12

		color: Constants.fontColor

		horizontalAlignment: Text.AlignHCenter

		background: Rectangle {
			width: parent.width - 2
			height: parent.height - 1

			color: Constants.popupBackgroundColor
		}
	}

	background: Rectangle {
		color: Constants.popupBackgroundColor
		border.color: "black"
		border.width: 1
	}

	footer: DialogButtonBox {
		x: 1
		y: 1

		alignment: Qt.AlignHCenter | Qt.AlignVCenter
		delegate: TimelineButton {}

		padding: 0
		spacing: 5

		background: Rectangle {
			implicitHeight: 40

			width: parent.width - 2
			height: parent.height - 1

			color: Constants.popupBackgroundColor
		}

	}
}
