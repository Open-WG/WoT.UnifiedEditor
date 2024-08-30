import QtQuick 2.11
import WGTools.Controls 2.0 as C
import WGTools.Debug 1.0
import "Details"

Page {
	property alias control: control
	title: "RangeSlider"
	
	Column {
		spacing: 10
		anchors.centerIn: parent

		C.TextField {
			placeholderText: "press Tab"
		}

		C.RangeSlider {
			id: control
			from: 0
			to: 100

			BB{c: "blue"; visible: debugMode}
			BB{a:control.contentItem; visible: debugMode}
		}

		C.TextField {
			placeholderText: "press Shift+Tab"
		}
	}
}
