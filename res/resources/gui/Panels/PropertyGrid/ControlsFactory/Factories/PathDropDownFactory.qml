import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'allMeta': ["Meta::View::Path", {'anyMeta': ["Meta::Option::List", "Meta::Option::Map"]}]
	}

	component: Qt.createComponent("../Delegates/PathDropDownDelegate.qml")
	properties: function(model) { return {model: model} }
}
