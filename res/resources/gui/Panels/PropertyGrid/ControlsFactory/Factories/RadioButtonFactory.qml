import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "bool",
		'meta': "Meta::View::RadioButton"
	}
	
	component: Qt.createComponent("../Delegates/RadioButtonDelegate.qml")
	properties: function(model) { return {model: model} }
}
