import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "lod_camera"
	}

	component: Qt.createComponent("../Delegates/LodCameraDelegate.qml")
	properties: function(model) { return {model: model} }
}
