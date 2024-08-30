import QtQuick 2.7
import WGTools.Utils 1.0
import "Constants.js" as Constants

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "range"
	}
	
	component: Qt.createComponent("../Delegates/RangeDelegate.qml")
	properties: function(model) { return {model: model} }
}
