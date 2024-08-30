import QtQml.Models 2.11
import QtQuick 2.11
import WGTools.ControlsEx 1.0 as C
import WGTools.Debug 1.0
import "Details"

Page {
	property alias control: control
	title: "FilterableComboBox"

	C.FilterableComboBox {
		id: control
		anchors.centerIn: parent

		currentIndex: 0
		sourceModel: ListModel {
			ListElement {name: "item 1"; value: 0}
			ListElement {name: "item 2"; value: 1}
			ListElement {name: "item 3"; value: 2}
			ListElement {name: "item 4"; value: 3}
		}

		BB{c: "blue"; visible: debugMode}
		BB{c: "green"; a:control.indicator; visible: debugMode}
		BB{a:control.contentItem; visible: debugMode}
	}
}
