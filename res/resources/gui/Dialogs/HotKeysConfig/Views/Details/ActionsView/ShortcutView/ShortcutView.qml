import QtQuick 2.11
import WGTools.Controls 2.0

Row {
	id: view
	spacing: 3

	property string shortcut

	Repeater {
		id: repeater
		model: view.shortcut.length ? view.shortcut.split('+') : null
		ButtonView {
			y: (parent.height - height) / 2
			text: modelData
		}
	}

	Label {
		y: (parent.height - height) / 2
		text: "None"
		color: _palette.color3
		visible: repeater.count == 0
	}
}
