import QtQuick 2.7
import WGTools.Utils 1.0
import "Constants.js" as Constants

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': Constants.numericTypes,
		'allMeta': ["!Meta::NoSlider", "!Meta::NoSpinBox", "Meta::View::Compact"]
	}
	
	component: Qt.createComponent("../Delegates/CompactNumericDelegate.qml")
	properties: function(model) { return {model: model} } 
}
