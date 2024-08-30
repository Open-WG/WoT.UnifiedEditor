import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "fog_minimap"
	}

	component: Qt.createComponent("../Delegates/FogMinimapDelegate.qml")
	properties: function(model) { return {model: model} }
}
