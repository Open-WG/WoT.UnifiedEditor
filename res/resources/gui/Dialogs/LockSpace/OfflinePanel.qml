import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.Misc 1.0 as Misc

Item {
	Image {
		id: image
		anchors.centerIn: parent
		source: "image://gui/modes/lock_space_tree_offline"
	}

	Misc.Text {
		id: text1
		anchors.top: image.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.topMargin: 16

		text: "Offline mode"
		font.pixelSize: 18
	}

	Misc.Text {
		anchors.top: text1.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.topMargin: 8
		text: "To enable SVN–operations please switch to online mode"
	}
}
