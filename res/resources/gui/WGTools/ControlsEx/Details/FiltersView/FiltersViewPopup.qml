import QtQuick 2.11
import WGTools.Controls 2.0

Menu {
	id: menu
	x: control.padding
	y: (control.indicator ? (control.indicator.y + control.indicator.height) : parent.height) + control.spacing

	TextField{
		onTextEdited: control.collectionFilter = text
		Binding on text {value: control.collectionFilter}
	}
	
	MenuItem {text: "Show all"; onClicked: control.showAll()}
	MenuItem {text: "Hide all"; onClicked: control.hideAll()}
	
	
	Repeater {
		model: control.collectionDelegateModel
	}

	MenuSeparator {}
	MenuItem {text: "Select All"; onClicked: control.selectAll()}
	MenuItem {text: "Deselect All"; onClicked: control.deselectAll()}
	MenuItem {text: "Toggle Selection"; onClicked: control.toggleSelection()}
}
