import QtQuick 2.7
import WGTools.Utils 1.0
import "Constants.js" as Constants

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': Constants.numericTypes,
		'anyMeta': [{'allMeta': ["Meta::NoSlider", "!Meta::NoSpinBox"]}, {'allMeta': ["!Meta::MinMax", "!Meta::MinMaxEditBounds", "!Meta::NoSlider", "!Meta::NoSpinBox"]}]
	}

	component: Qt.createComponent("../Delegates/SpinBoxDelegate.qml")
	properties: function(model) { return {model: model} }
}
