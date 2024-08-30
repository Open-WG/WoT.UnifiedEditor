import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'meta': "Meta::View::ComboBox"
	}

	component: Qt.createComponent("../Delegates/DropDownDelegate.qml")
	properties: function(model) { return {model: model} }
}
