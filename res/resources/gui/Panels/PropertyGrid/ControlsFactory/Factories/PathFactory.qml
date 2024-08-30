import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'meta': ["Meta::View::Path", "Meta::View::ImagePath"]
	}

	component: Qt.createComponent("../Delegates/PathDelegate.qml")
	properties: function(model) { return {model: model} }
}
