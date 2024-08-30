import QtQuick 2.11
import QtQml.Models 2.11
import QtQuick.Layouts 1.11
import WGTools.Controls 2.0
import WGTools.Controls.impl 1.0 as Impl

RowLayout {
	property var extendedFilterButton: undefined
	property alias useFilter: mainButton.active
	property alias checked: mainButton.checked

	property bool pressed: false

	id: filter
	spacing: 0

	MainFilterButton {
		id: mainButton
		onClicked: {
			let ctrlPressed = Qt.ControlModifier == (Impl.KeyModifiersMonitor.modifiers & Qt.ControlModifier)
			if (useFilter) {
				processMainButtonClick(ctrlPressed)
			} else if (!ctrlPressed) {
				// in this case the button will be checked but the filter will not be added
				setCheckedOnly() 
			}
			activateExtendedFilter(checked)
		}
		onPressed: {
			filter.pressed = true
		}
	}

	Loader {
		id: loader
		onLoaded: {
			item.menuLoader.setSource(model.menu)
			extendedFilterButton = item
		}
	}

	Component.onCompleted: {
		Impl.KeyModifiersMonitor.modifiers
		if (model.menu != undefined) {
			loader.setSource("ExtendedFilterButton.qml")
			mainButton.setLeftRounded()
		}
	}

	onCheckedChanged: {
		if (!pressed) {
			activateExtendedFilter(checked)
		}
		pressed = false
	}

	function processMainButtonClick(ctrlPressed) {
		if (checked) {
			if (!ctrlPressed) {
				removeOtherFilters()
			}
			mainButton.addFilter()
		} else {
			if (ctrlPressed || checkedButtonsCount() == 0) {
				mainButton.removeFilter(true)
			} else {
				removeOtherFilters()
			}
		}
	}

	function removeOtherFilters() {
		for (var i = 0; i < repeater.count; ++i) {
			var item = repeater.itemAt(i)

			if (item != filter && item.checked) {
				item.removeFilter(false)
			}
		}
		context.applyQuery()
	}

	function checkedButtonsCount() {
		let count = 0

		for (var i = 0; i < repeater.count; ++i) {
			if (repeater.itemAt(i).checked)
				++count
		}

		return count
	}

	function removeFilter(apply) {
		if (useFilter) {
			activateExtendedFilter(checked)
			mainButton.removeFilter(apply)
		} else {
			checked = false
		}
	}

	function setCheckedOnly() {
		if (checked || checkedButtonsCount() != 0) {
			for (var i = 0; i < repeater.count; ++i) {
				var item = repeater.itemAt(i)

				if (item != filter && item.checked) {
					item.checked = false
				}
			}
			checked = true
		}
	}

	function hasExtendedFilter() {
		return extendedFilterButton ? extendedFilterButton.checked : false
	}

	function removeExtendedFilter() {
		if (extendedFilterButton != undefined) {
			extendedFilterButton.clear()
		}
	}

	function activateExtendedFilter(active) {
		if (extendedFilterButton != undefined) {
			extendedFilterButton.setActive(active)
		}
	}
}
