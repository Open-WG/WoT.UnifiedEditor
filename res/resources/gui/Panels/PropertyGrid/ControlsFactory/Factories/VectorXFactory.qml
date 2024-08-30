import QtQuick 2.7
import WGTools.Utils 1.0
import "Constants.js" as Constants

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': Constants.vectorXTypes
	}
	
	component: Qt.createComponent("../Delegates/MultiSpinBoxDelegate.qml")
	properties: function(model) { return {model: model} }
}
