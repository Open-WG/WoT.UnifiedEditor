import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'meta': "Meta::View::RadioButtons"
	}

	component: Qt.createComponent("../Delegates/RadioButtonsDelegate.qml")
	properties: function(model) { return {model: model} }
}
