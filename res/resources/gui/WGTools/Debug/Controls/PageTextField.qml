import QtQuick 2.11
import WGTools.Controls 2.0 as C
import WGTools.Debug 1.0
import "Details"

Page {
	title: "TextField"
	
	C.TextField {
		id: control
		placeholderText: "Placeholder text"
		anchors.centerIn: parent

		BB{c: "blue"; visible: debugMode}
	}
}
