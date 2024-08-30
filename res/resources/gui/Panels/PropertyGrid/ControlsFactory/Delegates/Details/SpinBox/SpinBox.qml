import QtQuick 2.7
import WGTools.Controls 2.0
import WGTools.Controls.Controllers 1.0
import WGTools.Controls.impl 1.0 as Impl
import "../../Settings.js" as Settings
import WGTools.Utils 1.0
import WGTools.Misc 1.0 as Misc
import WGTools.PropertyGrid 1.0 as PG

DoubleSpinBox {
	id: spinbox

	property var valueData
	readonly property bool undefinedState: valueData == undefined || valueData.value == undefined

	property alias valueMin: validator.bottom
	property alias valueMax: validator.top

	signal modified(bool commit)

	Accessible.name: label.text || "Spin box"

	implicitWidth: Settings.widthSpinBox
	from: spinbox.valueMin
	to: spinbox.valueMax
	wheelEnabled: activeFocus && propertyGrid.controlsWheelEnabled
	units: valueData && valueData.units ? valueData.units.defaultUnits : ""

	onFocusChanged: console.trace()

	validator: Impl.DoubleValidator {
		id: validator
		locale: spinbox.locale.name
		bottom: Number.NEGATIVE_INFINITY
		top: Number.POSITIVE_INFINITY
		decimals: spinbox.decimals
		notation: DoubleValidator.StandardNotation
	}

	textFromValue: function(value, locale, decimals) {
		if (undefinedState) {
			return Settings.undefinedStateStringValue
		}

		return Utils.textFromValue(value, locale, decimals) + postfixText
	}

	property var modifiedFunction: function(commit) {
		var commitValue = customSetter();
		if (commitValue.toString() == "NaN") {
			valueData.setValue(
				valueData.value,
				(!commit ? PG.IValueData.TRANSIENT : 0) | PG.IValueData.IGNORE_SOFT_LIMITS
			)
		} else if (valueData != undefined && valueData.hasOwnProperty("setValue")) {
			valueData.setValue(
				commitValue,
				(!commit ? PG.IValueData.TRANSIENT : 0) | PG.IValueData.IGNORE_SOFT_LIMITS
			 )
		}
	}
	onModified: modifiedFunction(commit)

	function customSetter() {
		return value // Base implementation. Can be overriden.
	}

	function customGetter() {
		return spinbox.valueData.value // Base implementation. Can be overriden.
	}

	Binding on value {
		value: spinbox.undefinedState ? NaN : customGetter()
	}

	Binding on decimals {
		when: valueData != undefined;
		value: valueData != undefined ? valueData.valuePrecision : spinbox.decimals
	}

	Binding on stepSize {
		when: valueData != undefined;
		value: valueData != undefined ? valueData.valueStep : spinbox.valueStep
	}

	Binding on valueMin {
		when: valueData != undefined;
		value: valueData != undefined ? valueData.valueMinHard : spinbox.valueMin
	}

	Binding on valueMax {
		when: valueData != undefined;
		value: valueData != undefined ? valueData.valueMaxHard : spinbox.valueMax
	}

	Keys.forwardTo: controller
	SpinBoxController {
		id: controller
		onModified: {
			spinbox.modified(commit)
		}

		onRollback: {
			spinbox.displayTextChanged()
			spinbox.valueData.rollback()
		}
	}

	Misc.QmlEventFilter {
		target: spinbox.contentItem
	}
}
