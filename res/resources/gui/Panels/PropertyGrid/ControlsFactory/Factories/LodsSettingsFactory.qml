import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "lods_settings"
	}

	component: Qt.createComponent("../Delegates/LodsSettingsDelegate.qml")
	properties: function(model) { return {model: model} }
}
