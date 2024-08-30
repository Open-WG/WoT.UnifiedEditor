import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "resize_minimap"
	}

	component: Qt.createComponent("../Delegates/ResizeMinimapDelegate.qml")
	properties: function(model) { return {model: model} }
}
