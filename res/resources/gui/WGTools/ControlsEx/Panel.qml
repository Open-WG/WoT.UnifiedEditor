import QtQuick 2.11
import WGTools.Clickomatic 1.0

Rectangle {
	property var title: "<unknown>"
	property var layoutHint: "bottom"

	Accessible.name: title
	Accessible.role: ClickomaticConstants.FLOATING_PANEL_ROLE

	implicitWidth: 300
	implicitHeight: 300

	color: _palette.color8
}
