import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

Item {
	Misc.Text {
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.leftMargin: 10

		text: (modelData != null) ? modelData : model.display
		enabled: false
	}
}
