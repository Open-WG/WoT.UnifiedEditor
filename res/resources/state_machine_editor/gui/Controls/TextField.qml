import QtQuick 2.7
import QtQuick.Controls 2.3

TextField {
	id: control
	
	color: "white"

	background: Rectangle {
		color: "black"
		radius: 3
	}

	font.pixelSize: 12
	font.family: "Proxima Nova Rg"
	font.bold: true

	onAccepted: {
		control.parent.forceActiveFocus()
	}
}
