import QtQuick 2.7
import WGTools.Utils 1.0
import "Constants.js" as Constants

ItemFactory {
	choiceCriteria:
	{
		'propertyTypes': "normalized_playback"
	}
	
	component: Qt.createComponent("../Delegates/NormalizedPlaybackDelegate.qml")
	properties: function(model) { return {model: model} }
}
