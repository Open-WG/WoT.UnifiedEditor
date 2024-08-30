import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "unbound_margin"
	}

	component: Qt.createComponent("../Delegates/Unbound/UnboundMarginDelegate.qml")
	properties: function(model) { return {model: model} }
}
