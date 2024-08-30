import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Controls.impl 1.0 as Impl

// TODO: This is a prototype. Some implementations can be ugly.

Button {
	id: control
	text: model.display
	checkable: true

	function escapeRegExp(string){
		return string.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
	}

	function filterRegExp() {
		let pattern = "(?:^|[\\s]+)" + escapeRegExp(model.filter) + "\\b"
		return new RegExp(pattern, "i")
	}

	function addFilter() {
		if (context.queryEditProxy.text != "") {
			context.queryEditProxy.text += " "
		}

		context.queryEditProxy.text += model.filter
		context.applyQuery()
	}

	function removeFilter(apply) {
		let newQueryFilters = context.queryFilters.replace(filterRegExp(), '')

		context.queryEditProxy.text = context.queryPath
		context.queryEditProxy.text += "/ "
		context.queryEditProxy.text += newQueryFilters

		if (apply == true)
			context.applyQuery()
	}

	function removeOtherFilers() {
		let removed = true

		for (var i=0; i<repeater.count; ++i) {
			var item = repeater.itemAt(i)

			if (item == control)
				continue;

			if (!item.checked)
				continue;

			item.removeFilter(false)
		}

		if (removed)
			context.applyQuery()
	}

	function checkedButtonsCount() {
		let count = 0

		for (var i=0; i<repeater.count; ++i) {
			var item = repeater.itemAt(i)

			if (item.checked)
				++count
		}

		return count
	}

	onClicked: {
		let checkedCount = 0
		let ctrlPressed = Qt.ControlModifier == (Impl.KeyModifiersMonitor.modifiers & Qt.ControlModifier)

		if (checked) {
			if (!ctrlPressed) {
				removeOtherFilers()
			}
			addFilter()
		} else {
			if (ctrlPressed || checkedButtonsCount() == 0) {
				removeFilter(true)
			} else {
				removeOtherFilers()
			}
		}
	}

	ToolTip.visible: hovered
	ToolTip.delay: ControlsSettings.tooltipDelay
	ToolTip.timeout: ControlsSettings.tooltipTimeout
	ToolTip.text:
		"Filter: \"" + model.filter + "\"\n" +
		"Ctrl: multiple selection"

	Component.onCompleted: {
		Impl.KeyModifiersMonitor.modifiers
	}

	Binding on checked {
		value: filterRegExp().test(context.queryFilters)
	}
}
