import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "unbound_align"
	}

	component: Qt.createComponent("../Delegates/Unbound/UnboundAlignDelegate.qml")
	properties: function(model) { return {model: model} }
}
