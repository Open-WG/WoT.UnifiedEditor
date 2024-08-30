import QtQuick 2.10

Row {
	id: layout
	property var model

	spacing: 8
	padding: 4

	Repeater {
		model: layout.model
		delegate: Loader {
			source: model.action != undefined ? "ToolbarButton.qml" : "ToolbarSeparator.qml"
		}
	}	
}
