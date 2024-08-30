import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'meta': "Meta::View::TabbedRadioButtons"
	}

	component: Qt.createComponent("../Delegates/TabbedRadioButtonsDelegate.qml")
	properties: function(model) { return {model: model} }
}
