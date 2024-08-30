import QtQuick 2.11
import QtQuick.Layouts 1.3
import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.Buttons 1.0

import "../SequenceTimeline/Buttons" as STButtons
import "../SequenceTimeLine/Timeline" as STTimeline

Rectangle {
	anchors.fill: parent
	color: "transparent"

	ColumnLayout {
		width: parent.width
		anchors.centerIn: parent

		Image {
			source: "image://gui/animation_sequence/transitions/no_sequence"
			Layout.alignment: Qt.AlignHCenter
		}
		
		STTimeline.TimelineMessageText {
			text: context ? context.modelSelected ? "No state machine opened" : "No model selected" : "Error"
			visible: context && !context.modelHasStateMachine
			
			Layout.alignment: Qt.AlignHCenter
		}

		STTimeline.TimelineMessageText {
			text: "To start editing state machine open or create a file"
			visible: context && context.modelSelected && !context.modelHasStateMachine

			font.pixelSize: 12
			Layout.alignment: Qt.AlignHCenter
		}

		RowLayout {
			visible: context && context.modelSelected

			Layout.alignment: Qt.AlignHCenter
			Layout.topMargin: 12

			STButtons.TimelineButton {
				text: "Create"
				padding: 4
				onClicked: context.createStateMachine()

				Layout.preferredWidth: 60
			}

			STButtons.TimelineButton {
				text: "Open"
				padding: 4
				onClicked: context.openStateMachine()

				Layout.preferredWidth: 60
			}
		}
	}
}
