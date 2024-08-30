import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "tag"
	}
	
	component: Qt.createComponent("../Delegates/TagDelegate.qml")
	properties: function(model) { return {model: model} }
}
