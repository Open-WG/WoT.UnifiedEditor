import QtQuick 2.10
import QtQuick.Controls.impl 2.3 as Impl

Item {
	id: icon
	width: height * opacity
	visible: opacity
	clip: true

	Behavior on opacity {
		NumberAnimation { duration: 200 }
	}

	Impl.ColorImage {
		source: "image://gui/icon-magnifier"
		color: _palette.color2
		anchors.centerIn: parent
	}
}
