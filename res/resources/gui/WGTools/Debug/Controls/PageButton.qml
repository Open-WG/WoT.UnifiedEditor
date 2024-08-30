import QtQuick 2.11
import WGTools.Controls 2.0 as C
import WGTools.Debug 1.0
import "Details"

Page {
	property alias control: control
	title: "Button"
	
	C.Button {
		id: control
		text: "Button"
		icon.source: "image://gui/edit"
		anchors.centerIn: parent

		BB{c: "blue"; visible: debugMode}
		BB{a:control.contentItem; visible: debugMode}
	}
}
