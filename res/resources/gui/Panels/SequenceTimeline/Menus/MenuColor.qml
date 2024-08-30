import QtQuick 2.11
import WGTools.Controls 2.0

Menu {
	property int colorIndex: -1
	signal triggered(int index)

	implicitWidth: 120

	ButtonGroup { id: group }
	Repeater {
		model: context.colors
		delegate: MenuItem {
			checkable: true
			text: model.display

			icon.color: model.color
			icon.source: "image://gui/shapes/circle"

			ButtonGroup.group: group
			Binding on checked {value: index == menu.colorIndex}

			onTriggered: {
				menu.triggered(index)
			}
		}
	}
}
