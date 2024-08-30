import QtQuick 2.7
import WGTools.Utils 1.0
import "Constants.js" as Constants

ItemFactory {
	choiceCriteria:
	{
		'meta': "Meta::Units"
	}
	
	component: Qt.createComponent("../Delegates/UnitsSpinBoxDelegate.qml")
	properties: function(model) { return {model: model} }
}
