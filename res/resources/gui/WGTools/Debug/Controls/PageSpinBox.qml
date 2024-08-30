import QtQuick 2.11
import WGTools.Controls 2.0 as C
import WGTools.Debug 1.0
import "Details"

Page {
	property alias control: control
	title: "SpinBox"
	
	C.DoubleSpinBox {
		id: control
		to: 99999999
		anchors.centerIn: parent

		BB{c: "blue"; visible: debugMode}
		BB{a:control.contentItem; visible: debugMode}
	}
}
