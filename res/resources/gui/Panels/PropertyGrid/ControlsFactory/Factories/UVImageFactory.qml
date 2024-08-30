import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'meta': "Meta::View::UVImage"
	}

	component: Qt.createComponent("../Delegates/UVImageDelegate.qml")
	properties: function(model) { return {model: model}	}
}
