import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "Method"
	}
	
	component: Qt.createComponent("../Delegates/ButtonDelegate.qml")
	properties: function(model) { return {model: model} }
}
