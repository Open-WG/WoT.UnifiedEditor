import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'meta': "Meta::View::ImageRadioButtons"
	}

	component: Qt.createComponent("../Delegates/ImageRadioButtonsDelegate.qml")
	properties: function(model) { return {model: model} }
}
