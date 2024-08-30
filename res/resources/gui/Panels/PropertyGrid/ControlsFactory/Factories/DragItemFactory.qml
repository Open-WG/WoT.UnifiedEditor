import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
	choiceCriteria:
	{
		'meta': "Meta::View::DragItem"
	}

	component: Qt.createComponent("../Delegates/DragItemDelegate.qml")
	properties: function(model) { return {model: model} }
}
