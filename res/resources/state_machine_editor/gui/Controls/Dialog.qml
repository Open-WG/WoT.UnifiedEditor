import QtQuick 2.10
import QtQuick.Controls 2.3
import Controls 1.0 as SMEControls

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

		font.family: "Proxima Nova Rg"
		font.bold: true
		font.pixelSize: 12

		color: "white"

		horizontalAlignment: Text.AlignHCenter

		background: Rectangle {
			width: parent.width - 2
			height: parent.height - 1

			color: "#4a4a4a"
		}
	}

	background: Rectangle {
		color: "#4a4a4a"
		border.color: "black"
		border.width: 1
	}

	footer: DialogButtonBox {
		x: 1
		y: 1

		alignment: Qt.AlignHCenter | Qt.AlignVCenter
		delegate: SMEControls.Button {}

		padding: 0
		spacing: 5

		background: Rectangle {
			implicitHeight: 40

			width: parent.width - 2
			height: parent.height - 1

			color: "#4a4a4a"
		}

	}
}
