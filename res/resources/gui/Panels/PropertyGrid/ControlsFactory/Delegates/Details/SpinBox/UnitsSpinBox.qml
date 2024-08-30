import QtQuick 2.7
import WGTools.Controls.impl 1.0 as Impl
import WGTools.Controls 2.0
import "../../Settings.js" as Settings
import "../SpinBox" as Details

Details.SpinBox {
	id: spinbox

	property string unitsText
	property var numericRegExp: /^[+-]?\d+[\.,]?\d*/

	units: undefinedState ? "" : valueData.value.type
	value: undefinedState ? NaN : valueData.value.value
	
	Accessible.name: label.text || "Units spin box"

	inputMethodHints: Qt.ImhDigitsOnly

	validator: Impl.DoubleUnitsValidator {
		numericPattern: numericRegExp.source
		locale: spinbox.locale.name
		bottom: Number.NEGATIVE_INFINITY
		top: Number.POSITIVE_INFINITY 
		decimals: spinbox.decimals
		notation: DoubleValidator.StandardNotation
	}

	valueFromText: function(text, locale) {
		var numericText = text.match(numericRegExp)
		
		try {
			return Number.fromLocaleString(locale, numericText);
		} catch (e) {
			return value
		}
	}

	onValueAboutToBeModified: {
		if (contentItem.text) {
			var match = contentItem.text.match(numericRegExp)
			unitsText = match ? contentItem.text.substr(match[0].length) : contentItem.text
		} else {
			unitsText = valueData != undefined ? valueData.units.defaultUnits : ""
		}
	}

	function customSetter() { // override
		return Impl.TypedNumber.create(value, unitsText)
	}

	function setUnits(unitsValue) {
		unitsText = unitsValue
		modified(true)
	}

	Component {
		id: unitsContextMenuItem
		
		MenuItem {
			onTriggered: {
				spinbox.setUnits(text)
			}
		}
	}

	property var extendContextMenu: function(menu) {
		menu.addSeparator()

		var unitsList = valueData.units.unitsList
		var unitsListLength = unitsList.length
		for (var i = 0; i < unitsListLength; ++i) {
			menu.addMenu(unitsContextMenuItem.createObject(menu.contentItem, {text: unitsList[i]}))
		}
	}
}
