import QtQuick 2.10
import QtQml.Models 2.2
import WGTools.Controls 2.0
import "../../Preview"

Repeater {
	id: menu
	property PreviewSettings settings

	model: ListModel {
		ListElement {text: "Checkerboard"; color: "transparent"; icon: "image://gui/texture_asset/checkerboard-on"}
		ListElement {text: "Pink Background"; color: "#FFBABA"; icon: "image://gui/img-bg-pink"}
		ListElement {text: "White Background"; color: "#FFFFFF"; icon: "image://gui/img-bg-white"}
		ListElement {text: "Black Background"; color: "#000000"; icon: "image://gui/img-bg-black"}
	}

	ColorMenuItem {
		id: colorItem
		text: model.text
		color: model.color
		icon.source: model.icon
		icon.color: "transparent"
		enabled: menu.settings
		readonly property bool isCheckerboard: text == "Checkerboard"

		onTriggered: {
			menu.settings.checkerboard = isCheckerboard
			menu.settings.backgroundColor = color
			checked = true
		}

		Binding on checked {
			value: menu.settings && (!menu.settings.checkerboard && menu.settings.backgroundColor == colorItem.color || menu.settings.checkerboard && colorItem.isCheckerboard)
		}
	}
}
