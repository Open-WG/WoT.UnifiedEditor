import QtQuick 2.11
import WGTools.Controls 2.0 as C
import WGTools.Debug 1.0
import "Details"

Page {
	property alias control: control
	title: "RadioDelegate"
	
	Column {
		anchors.centerIn: parent

		C.RadioDelegate {
			id: control
			text: "RadioDelegate"
			icon.source: "image://gui/edit"
			

			BB{c: "blue"; visible: debugMode}
			BB{a:control.contentItem; visible: debugMode}
		}

		C.RadioDelegate {
			text: "RadioDelegate2"
			icon.source: "image://gui/edit"

			BB{c: "blue"; visible: debugMode}
			BB{a:control.contentItem; visible: debugMode}
		}
	}
}
