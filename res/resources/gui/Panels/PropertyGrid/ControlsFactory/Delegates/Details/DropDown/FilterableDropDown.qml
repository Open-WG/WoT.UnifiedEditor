import QtQuick 2.11
import WGTools.ControlsEx 1.0
import "../../Settings.js" as Settings

FilterableComboBox {
	id: combobox
	sourceModel: propertyData ? propertyData.options : null

	Accessible.name: "Dropdown"

	onActivated: {
		var newValue = propertyData.options.valueAt(index)
		propertyData.setValue(newValue)
	}

	Binding on currentIndex {
		value: combobox.sourceModel ? combobox.sourceModel.indexOf(propertyData.value) : -1
	}

	Binding on displayText {
		value: Settings.undefinedStateStringValue
		when: !propertyData || propertyData.value == undefined
	}

	Binding on displayText {
		value: combobox.currentText
		when: propertyData && propertyData.value != undefined
	}
}
