import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "lod_bar"
	}

	component: Qt.createComponent("../Delegates/LodBarDelegate.qml")
	properties: function(model) { return {model: model} }
}
