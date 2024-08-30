import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import Panels.SequenceTimeline 1.0

Button {
	hoverEnabled: true
	focusPolicy: Qt.NoFocus

	background: Rectangle {
		color: parent.pressed ? Constants.playbackPressedButtonBackgroundColor : parent.hovered ? Constants.playbackHoveredButtonBackgroundColor : Constants.playbackButtonBackgroundColor
		border.width: 1
		border.color: "black"
	}
}