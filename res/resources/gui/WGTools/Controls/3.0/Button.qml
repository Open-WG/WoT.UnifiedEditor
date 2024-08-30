import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Style 1.0

T.Button {
	id: control
	
	property real pressedOffset

	implicitWidth: Math.max(background ? background.implicitWidth : 0, contentItem.implicitWidth + leftPadding + rightPadding)
	implicitHeight: Math.max(background ? background.implicitHeight : 0, contentItem.implicitHeight + topPadding + bottomPadding)
	baselineOffset: contentItem.y + contentItem.baselineOffset - (down ? pressedOffset : 0)
	hoverEnabled: true

	contentItem: Text {
		text: control.text
	}

	background: Rectangle {
		property color baseColor
		property color tintColor: "transparent"
		
		color: Qt.tint(baseColor, tintColor)
	}

	Style.class: {
		let v = "button"

		if (flat)
			v += "-flat"

		if (checked)
			v += "-checked"

		if (!enabled)         v += "-disabled"
		else if (pressed)     v += "-pressed"
		else if (hovered)     v += "-hovered"
		else if (visualFocus) v += "-highlighted"

		return v
	}
}
