import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "string",
		'meta': "Meta::View::TextArea"
	}
	
	component: Qt.createComponent("../Delegates/TextAreaDelegate.qml")
	properties: function(model) { return {model: model} }
}
