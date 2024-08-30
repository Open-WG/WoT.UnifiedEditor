import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0

Rectangle {
	id: control
	signal close
	property alias text: title.text
	property alias textColor: title.color
	readonly property bool hovered: area.containsMouse || removeButton.hovered
	color: enabled ? (hovered ? _palette.color3 : _palette.color5) : "transparent"
	width: title.x + title.width + removeButton.width + ControlsSettings.smallPadding
	height: ControlsSettings.iconSize
	radius: height / 2
	Accessible.name: text

	Rectangle {
		width: control.height
		height: width
		color: "#4C000000"
		radius: width / 2
		anchors.verticalCenter: parent.verticalCenter

		TagIcon {
			anchors.centerIn: parent
			text: title.text.substring(0, 1)
		}
	}

	T.TextField {
		id: title
		x: control.height + ControlsSettings.padding
		width: contentWidth
		height: parent.height
		anchors.verticalCenter: parent.verticalCenter
		readOnly: true
		color: enabled ? _palette.color1 : _palette.color3
	}

	MouseArea {
		id: area
		anchors.fill: parent
		hoverEnabled: true
	}

	BasicIndicatorButton {
		id: removeButton
		Accessible.name: "X"
		x: control.width - width
		width: control.height
		height: control.height
		source: "controls-tag-close"
		visible: enabled

		onClicked: {
			control.close()
		}
	}

	ColorBehavior on color {}
}