import QtQuick 2.7
import WGTools.Utils 1.0
import "Constants.js" as Constants

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "timeline"
	}
	
	component: Qt.createComponent("../Delegates/TimelineDelegate.qml")
	properties: function(model) { return {model: model} }
}
