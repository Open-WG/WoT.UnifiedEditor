import QtQuick 2.10
import WGTools.Misc 1.0 as Misc

Item {
	id: root

	property alias text: label.text
	property real spacing: 5

	implicitWidth: separator.width + label.width + spacing*2
	implicitHeight: Math.max(separator.height, label.height)

	Rectangle {
		id: separator
		width: 5
		height: width
		radius: width
		color: _palette.color3
		x: (parent.width - label.width - width) / 2
		y: (parent.height - height) / 2
	}

	Misc.Text {
		id: label
		color: _palette.color3
		x: parent.width - width
		y: (parent.height - height) / 2

		font.bold: true
	}
}
