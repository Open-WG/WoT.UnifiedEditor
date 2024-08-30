import QtQuick 2.7
import "../"

UnitsSpinBoxDelegate {
	property bool defaultUnitsMode: propertyData 
		? control.units.toUpperCase() === propertyData.units.defaultUnits.toUpperCase()
		: false
	
	Binding {
		target: control.contentItem
		property: "text"
		value: control.units
		when: defaultUnitsMode
	}

	Binding {
		target: control.unitsLabel
		property: "visible"
		value: false
		when: defaultUnitsMode
	}

	Binding {
		target: control
		property: "buttonsVisible"
		value: false
		when: defaultUnitsMode
	}

	Connections {
		target: control

		onActiveFocusChanged: {
			if (defaultUnitsMode && control.activeFocus) {
				control.contentItem.selectAll()
			}
		}

		onModified: {
			if (commit && defaultUnitsMode) {
				control.contentItem.text = control.units
			}
		}
	}
}
