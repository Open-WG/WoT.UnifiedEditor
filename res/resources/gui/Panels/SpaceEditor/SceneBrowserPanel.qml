import QtQuick 2.11
import WGTools.ControlsEx 1.0

Column {
	id: layout

	readonly property real clientWidth: width - leftPadding - rightPadding

	padding: 4
	spacing: 2

	SearchField {
		id: filterTextField
		width: layout.clientWidth
		placeholderText: "Filter"
		text: viewContext.model.filterTokens

		onTriggered: viewContext.model.filterTokens = filterTextField.text
	}
}
