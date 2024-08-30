import QtQuick 2.7
import WGTools.Utils 1.0
import "Constants.js" as Constants

ItemFactory {
	choiceCriteria:
	{
		'meta': "Meta::Units",
		'propertyTypes': "unbound_spinbox",
	}
	
	component: Qt.createComponent("../Delegates/Unbound/UnboundSpinBoxDelegate.qml")
	properties: function(model) { return {model: model} }
}
