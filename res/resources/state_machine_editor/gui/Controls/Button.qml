import QtQuick 2.7
import QtQuick.Controls 2.3
import Controls 1.0 as SMEControls

Button {
	id: root

	property var textColor: "#ffffff"

	implicitWidth: contentText.contentWidth + leftPadding + rightPadding

	hoverEnabled: true
	focusPolicy: Qt.NoFocus

	padding: 0
	leftPadding: 10
	rightPadding: 10
	topPadding: 5
	bottomPadding: 5

	contentItem: SMEControls.Text {
		id: contentText

		text: root.text

		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter

		color: enabled ? textColor : "#d4d4d4"
	}

	background: Rectangle {
		id: buttonBackground

		property bool borderVisible: false
		property alias borderRadius: buttonBackground.radius

		visible: !root.flat

		color: enabled ? "#8c8c8c" : "#666666"
		radius: 3

		border.color: borderVisible ? "black" : "transparent"
		border.width: 0

		Rectangle {
			id: addColorLayer

			visible: root.hovered || root.pressed

			anchors.fill: parent
			anchors.margins: parent.border.width

			radius: parent.radius

			color: getColor()

			function getColor() {
				if (root.pressed) {
					return Qt.rgba(0, 0, 0, 0.6)
				}
				else {
					return Qt.rgba(1, 1, 1, 0.25)
				}
			}
		}
	}
}