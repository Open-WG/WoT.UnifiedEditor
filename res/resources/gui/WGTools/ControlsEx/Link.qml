import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0 as Details

Label {
	id: control

	property string linkAddress
	property string linkText

	activeFocusOnTab: true
	text: "<a href='" + linkAddress + "'>" + (linkText.length ? linkText : linkAddress) + "</a>"
	onLinkActivated: Qt.openUrlExternally(link)

	background: Details.TextFieldBackground {
		implicitWidth: 0
		implicitHeight: 0
		radius: 0
		color: "transparent"
		border.color: control.activeFocus ? _palette.color1 : color
	}

	MouseArea {
		acceptedButtons: Qt.NoButton
		cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
		anchors.fill: parent
	}
}
