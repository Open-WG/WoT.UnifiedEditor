import QtQuick 2.7
import WGTools.Misc 1.0 as Misc
import "../Indicators" as Indicators

Item {
	id: root

	property var color

	Misc.CheckerboardImage {
		anchors.fill: parent
	}

	Rectangle {
		opacity: root.color == undefined ? 0 : 1
		anchors.fill: parent

		Binding on color {
			when: opacity
			value: root.color
		}
	}

	Indicators.UndefinedStateIndicator {
		opacity: root.color == undefined ? 1 : 0
		anchors.centerIn: parent
	}
}
