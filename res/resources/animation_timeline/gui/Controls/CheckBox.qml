import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.impl 2.3

import "..//Constants.js" as Constants

CheckBox {
	id: control

	indicator: Rectangle {

		implicitWidth: 10
		implicitHeight: 10

		x: text ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding + (control.availableWidth - width) / 2
		y: control.topPadding + (control.availableHeight - height) / 2

		color: control.down ? control.palette.light : control.palette.base
		border.width: control.visualFocus ? 2 : 1
		border.color: control.visualFocus ? control.palette.highlight : control.palette.mid

		ColorImage {
			x: (parent.width - width) / 2
			y: (parent.height - height) / 2
			defaultColor: "#353637"
			color: control.palette.text
			source: "qrc:/qt-project.org/imports/QtQuick/Controls.2/images/check.png"
			visible: control.checkState === Qt.Checked

			width: parent.width
			height: parent.height
		}

		Rectangle {
			x: (parent.width - width) / 2
			y: (parent.height - height) / 2
			width: 16
			height: 3
			color: control.palette.text
			visible: control.checkState === Qt.PartiallyChecked
		}
	}

	padding: 3
	spacing: 1

	contentItem: Text {
		leftPadding: control.indicator && !control.mirrored ? control.indicator.width + control.spacing : 0
		rightPadding: control.indicator && control.mirrored ? control.indicator.width + control.spacing : 0

		text: control.text
		font.family: Constants.proximaRg
		font.bold: true
		font.pixelSize: 12
		color: Constants.fontColor

		verticalAlignment: Text.AlignVCenter
	}
}
