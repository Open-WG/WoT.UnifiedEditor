import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import Panels.SequenceTimeline 1.0
import "..//Backgrounds"

Button {
	id: root
	Accessible.name: text

	property alias iconImage: icon.source
	property alias iconImageSize: icon.sourceSize
	property alias borderVisible: timelineBackground.borderVisible
	property alias borderRadius: timelineBackground.borderRadius

	// hasHoveredState helps to fix the bug with ColorOverlay::getColor() 
	// it returns wrong color for a button without hovered state
	property var hasHoveredState: true

	hoverEnabled: true
	focusPolicy: Qt.NoFocus

	padding: 0
	leftPadding: 10
	rightPadding: 10
	topPadding: 5
	bottomPadding: 5

	contentItem: RowLayout {
		id: content

		Image {
			id: icon

			Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

			visible: source != undefined

			fillMode: Image.Pad

			opacity: root.enabled ? 1 : 0.25

			ColorOverlay {
				visible: flat

				anchors.fill: icon
				source: icon

				color: getColor()

				function getColor() {
					if (!root.enabled) {
						return Constants.defaultFlatButtonDisabledColor
					}
					else if (root.pressed) {
						return Constants.defaultFlatButtonPressedColor
					}
					else if (root.hasHoveredState && root.hovered) {
						return Constants.defaultFlatButtonHoveredColor
					}
					return Qt.rgba(1, 1, 1, 0)
				}
			}
		}

		Text {
			id: textBox

			Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

			visible: root.text != ""

			text: !visible ? "" : root.text
			color: root.enabled ? _palette.color1 : _palette.color3

			font.pixelSize: 12
			font.family: Constants.proximaRg
			font.bold: true
		}
	}

	background: TimelineButtonBackground {
		id: timelineBackground
		visible: !flat
	}
}
