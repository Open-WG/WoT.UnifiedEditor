import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Controls.impl 1.0 as Impl

// TODO: This is a prototype. Some implementations can be ugly.

Button {
	id: control
	icon.source: "image://gui/icon-delete"

	ToolTip.text:
		"Remove all quick filters\n" +
		"Ctrl: remove all filters"

	ToolTip.visible: hovered
	ToolTip.delay: ControlsSettings.tooltipDelay
	ToolTip.timeout: ControlsSettings.tooltipTimeout

	Component.onCompleted: {
		Impl.KeyModifiersMonitor.modifiers
	}

	enabled: {
		for (var i = 0; i < repeater.count; ++i) {
			var item = repeater.itemAt(i)

			if (item.checked || item.hasExtendedFilter())
				return true
		}

		return false
	}

	onClicked: {
		let ctrlPressed = Qt.ControlModifier == (Impl.KeyModifiersMonitor.modifiers & Qt.ControlModifier)

		if (ctrlPressed) {
			removeAllFilters()
		} else {
			removeAllQuickFilters()
		}
	}

	function removeAllQuickFilters() {
		let removed = true

		for (var i = 0; i < repeater.count; ++i) {
			var item = repeater.itemAt(i)

			if (item.checked)
				item.removeFilter(false)
			item.removeExtendedFilter()
		}

		if (removed)
			context.applyQuery()
	}

	function removeAllFilters() {
		context.removeFilters()
	}
}
