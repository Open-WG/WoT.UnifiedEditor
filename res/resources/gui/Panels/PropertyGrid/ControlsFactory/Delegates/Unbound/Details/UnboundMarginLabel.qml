import QtQuick 2.7
import QtQuick.Controls 2.0
import WGTools.Controls.Details 2.0

Text {
	id: marginRect

	property var typedNumber

	text: typedNumber != undefined ? typedNumber.value + " " + typedNumber.type : ""
	color: _palette.color1
	font.pixelSize: ControlsSettings.textNormalSize
	font.underline: true

	MouseArea {
		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor
	}
}
