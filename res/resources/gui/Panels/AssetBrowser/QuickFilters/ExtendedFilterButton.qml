import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

RoundedButton {
	property var menuLoader: loader
	property var menu: undefined

	id: extendedFilterButton
	checkable: true
	transformOrigin: Item.BottomRight

	icon.source: "image://gui/filter_icon"
	icon.color: "transparent"

	ToolTip.visible: hovered
	ToolTip.delay: ControlsSettings.tooltipDelay
	ToolTip.timeout: ControlsSettings.tooltipTimeout
	ToolTip.text: "Extended filter"

	Loader {
		id: loader
		onLoaded: {
			item.x = Qt.binding(function() { return (extendedFilterButton.width - item.width) / 2})
			item.y = Qt.binding(function() { return extendedFilterButton.height })

			extendedFilterButton.clicked.connect(item.openEx)
			extendedFilterButton.menu = item
		}
	}

	Component.onCompleted: {
		setRightRounded()
	}

	Binding on checked {
		value: menu ? menu.hasChecked() : false
	}

	onClicked: {
		checked = menu.hasChecked()
	}

	function setActive(isActive) {
		if (menu != undefined) {
			menu.active = isActive
		}
	}

	function clear() {
		if (menu != undefined) {
			menu.clear()
		}
	}
}
