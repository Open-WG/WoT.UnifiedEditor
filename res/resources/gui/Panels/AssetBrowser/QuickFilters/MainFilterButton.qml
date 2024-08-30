import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Controls.impl 1.0 as Impl

RoundedButton {
	property bool active: true

	id: control
	text: model.display
	checkable: true
	icon.source: model.icon ? model.icon : ""
	icon.color: "transparent"

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

		context.queryEditProxy.text = context.queryPath + "/ " + newQueryFilters

		if (apply == true)
			context.applyQuery()
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

	onActiveChanged: { 
		if (checked) {
			if (active) {
				addFilter()
			} else {
				removeFilter(true)
			}
		}
	}

	Binding on checked {
		value: active ? filterRegExp().test(context.queryFilters) : checked
	}
}
