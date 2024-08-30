import QtQuick 2.11
import WGTools.ControlsEx 1.0
import "../../Settings.js" as Settings

FilterableComboBox {
	id: combobox

	property var propertyValue: propertyData ? propertyData.value : null
	sourceModel: propertyData ? propertyData.options : null

	Accessible.name: "Dropdown"

	onActivated: {
		var newValue = propertyData.options.valueAt(index)
		propertyData.setValue(newValue)
	}

	function updateCurrentIndex() {
		if (!sourceModel) {
			currentIndex = -1;
		} else if (sourceModel.valueAt(currentIndex) != propertyValue) {
			currentIndex = sourceModel.indexOf(propertyValue);
		}
	}

	// This is necessary for the increment and decrement current index
	// to work if there are several identical options.
	onPropertyValueChanged: updateCurrentIndex()

	Binding on displayText {
		value: Settings.undefinedStateStringValue
		when: !propertyData || propertyData.value == undefined
	}

	Binding on displayText {
		value: combobox.currentText
		when: propertyData && propertyData.value != undefined
	}
}
