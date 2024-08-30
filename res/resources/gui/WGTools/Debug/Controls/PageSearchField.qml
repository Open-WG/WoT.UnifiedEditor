import QtQuick 2.11
import WGTools.ControlsEx 1.0 as C
import WGTools.Debug 1.0
import "Details"

Page {
	title: "SearchField"
	
	C.SearchField {
		id: control
		placeholderText: "Placeholder text"
		anchors.centerIn: parent

		BB{c: "blue"; visible: debugMode}
	}
}
