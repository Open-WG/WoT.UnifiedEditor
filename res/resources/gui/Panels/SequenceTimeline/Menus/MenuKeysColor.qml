import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.AnimSequences 1.0

MenuColor {
	id: colorMenu
	title: "Colors"
	colorIndex: helper.colorIndex
	enabled: helper.enabled && !context.curveMode
	onTriggered: helper.set(index)

	Binding {
		target: colorMenu.parent
		property: "visible"
		value: colorMenu.enabled
	}

	ItemsColorHelper {
		id: helper
		model: rootSequenceTree.model
		selection: rootSequenceTree.selectionModel
	}
}
