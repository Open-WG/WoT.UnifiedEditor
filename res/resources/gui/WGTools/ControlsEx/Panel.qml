import QtQuick 2.11

Rectangle {
	property var title: "<unknown>"
	property var layoutHint: "bottom"

	Accessible.name: title

	implicitWidth: 300
	implicitHeight: 300

	color: _palette.color8
}
