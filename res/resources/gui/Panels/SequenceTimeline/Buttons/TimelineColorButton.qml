import QtQuick 2.11
import WGTools.Controls 2.0

Button {
	id: control

	property color color: "red"
	property bool solid: true

	hoverEnabled: false
	flat: true

	contentItem: Loader {
		sourceComponent: control.solid ? solidContent : notSolidContent
	}
	
	background: Rectangle {
		implicitWidth: 16
		implicitHeight: implicitWidth
		radius: width / 2
		color: _palette.color3
	}

	Component {
		id: notSolidContent

		Image {
			source: "image://gui/sequence-muticolor"
			sourceSize.width: 12
			sourceSize.height: 12
		}
	}

	Component {
		id: solidContent

		Rectangle {
			implicitWidth: 12
			implicitHeight: 12
			radius: width / 2
			color: control.color
		}
	}
}
