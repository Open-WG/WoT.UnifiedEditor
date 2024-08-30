import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "bool"
	}
	
	component: Qt.createComponent("../Delegates/CheckBoxDelegate.qml")
	properties: function(model) { return {model: model} }
}
