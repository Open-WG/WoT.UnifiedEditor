import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "color_gradient"
	}

	component: Qt.createComponent("../Delegates/ColorGradientDelegate.qml")
	properties: function(model) { return {model: model} }
}
