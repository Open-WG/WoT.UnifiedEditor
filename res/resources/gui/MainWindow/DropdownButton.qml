import QtQuick 2.7
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

Button {
	id: control

	property var menu

	implicitWidth: 30
	implicitHeight: 10
	hoverEnabled: true
	flat: true

	icon.color: "transparent"

	onPressed: {
		if (menu)
		{
			if (menu.hasOwnProperty("popupEx"))
				menu.openEx()
			else
				menu.open()
		}
	}

	// TODO: implement proper ButtonBackground instead of additional item workaround
	Rectangle {
		anchors.fill: parent
		z: -1
		color: parent.hovered || (menu && menu.visible)
			? _palette.color6
			: "transparent"
	}
}
