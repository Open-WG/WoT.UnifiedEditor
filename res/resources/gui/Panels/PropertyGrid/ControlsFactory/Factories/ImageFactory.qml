import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "image"
	}

	component: Qt.createComponent("../Delegates/ImageDelegate.qml")
	properties: function(model) { return {model: model} }
}
