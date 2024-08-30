import QtQuick 2.10
import WGTools.Misc 1.0 as Misc

Rectangle {
	property alias checkerboard: checkerboard

	Misc.CheckerboardImage {
		id: checkerboard
		width: parent.width
		height: parent.height
		anchors.centerIn: parent
	}
}
