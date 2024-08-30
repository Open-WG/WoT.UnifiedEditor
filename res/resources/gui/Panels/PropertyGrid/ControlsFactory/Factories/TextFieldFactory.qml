import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': ["string", "BW::DateTimeUtils::DateTime"]
	}
	
	component: Qt.createComponent("../Delegates/TextFieldDelegate.qml")
	properties: function(model) { return {model: model} }
}
