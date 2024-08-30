import QtQml.Models 2.11
import QtQuick 2.11
import WGTools.Controls 2.0 as C
import WGTools.Debug 1.0
import "Details"

Page {
	property alias control: control
	title: "ComboBox"

	C.ComboBox {
		id: control
		editText: "ComboBox"
		anchors.centerIn: parent

		currentIndex: 0
		textRole: "name"
		// model: 1000
		model: ListModel {
			ListElement {name: "item 1"; value: 0}
			ListElement {name: "item 2"; value: 1}
			ListElement {name: "item 3"; value: 2}
			// ListElement {name: "item 1"; value: 2}
			// ListElement {name: "item 2"; value: 3}
			// ListElement {name: "item 3"; value: 4}
			// ListElement {name: "item 1"; value: 5}
			// ListElement {name: "item 2"; value: 6}
			// ListElement {name: "item 3"; value: 7}
			// ListElement {name: "item 1"; value: 8}
			// ListElement {name: "item 2"; value: 9}
			// ListElement {name: "item 3"; value: 10}
			// ListElement {name: "item 1"; value: 11}
			// ListElement {name: "item 2"; value: 12}
			// ListElement {name: "item 3"; value: 13}
			// ListElement {name: "item 1"; value: 14}
			// ListElement {name: "item 2"; value: 15}
			// ListElement {name: "item 3"; value: 16}
			// ListElement {name: "item 1"; value: 17}
			// ListElement {name: "item 2"; value: 18}
			// ListElement {name: "item 3"; value: 19}
			// ListElement {name: "item 1"; value: 20}
			// ListElement {name: "item 2"; value: 21}
			ListElement {name: "item 3"; value: 22}
			ListElement {name: "item 1"; value: 23}
			ListElement {name: "item 2"; value: 24}
			ListElement {name: "item 3"; value: 25}
			ListElement {name: "item 4 veeeeeeery long text"; value: 26}
		}

		BB{c: "blue"; visible: debugMode}
		BB{c: "green"; a:control.indicator; visible: debugMode}
		BB{a:control.contentItem; visible: debugMode}
	}
}
