import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'meta': "Meta::View::ColorPicker"
	}

	component: Qt.createComponent("../Delegates/ColorDelegate.qml")
	properties: function(model) { return {model: model} }
}
