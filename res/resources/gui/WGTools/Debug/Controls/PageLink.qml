import QtQuick 2.11
import WGTools.ControlsEx 1.0 as C
import WGTools.Debug 1.0
import "Details"

Page {
	property alias control: control
	title: "Link"
	
	C.Link {
		id: control
		linkAddress: "https://myportal.wargaming.net/Minsk"
		linkText: "Portal"
		anchors.centerIn: parent

		BB{c: "blue"; visible: debugMode}
	}
}
