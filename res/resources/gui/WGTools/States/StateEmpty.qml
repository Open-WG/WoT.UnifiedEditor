import QtQuick 2.10
import QtGraphicalEffects 1.0

Item {
	Image {
		anchors.centerIn: parent
		source: "image://gui/no-image"
		
		ColorOverlay {
			anchors.fill: parent
			source: parent
			color: delegateRoot.__enabled ? _palette.color2 : _palette.color3
		}
	}
}