import QtQuick 2.11
import QtQuick.Layouts 1.3
import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.Buttons 1.0

Rectangle {
	width: 381
	height: 262
	radius: 3
	color: "transparent"
	visible: context ? !context.sequenceOpened || !context.modelSelected : true

	ColumnLayout {
		visible: context && !context.sequenceModel
		width: parent.width
		y: 13

		Image {
			source: Constants.noSequenceTransition
			Layout.alignment: Qt.AlignHCenter
		}

		TimelineMessageText {
			text: context ? context.modelSelected ? "No sequence opened" : "No model selected" : "Error"
			visible: context && !context.modelHasSequence
			
			Layout.alignment: Qt.AlignHCenter
		}

		TimelineMessageText {
			text: "This model has sequence. You can start editing"
			visible: context && context.modelHasSequence

			Layout.alignment: Qt.AlignHCenter
		}

		TimelineMessageText {
			text: "To start creating animation open or create sequence file"
			visible: context && context.modelSelected && !context.modelHasSequence

			font.pixelSize: 12
			Layout.alignment: Qt.AlignHCenter
		}

		RowLayout {
			visible: context && context.modelSelected

			Layout.alignment: Qt.AlignHCenter
			Layout.topMargin: 12

			TimelineButton {
				text: "Create"
				padding: 4
				onClicked: context.createSequence()

				Layout.preferredWidth: 60
			}

			TimelineButton {
				text: "Open"
				padding: 4
				onClicked: context.openSequence()

				Layout.preferredWidth: 60
			}

			TimelineButton {
				text: "Edit"
				padding: 4
				visible: context ? context.modelHasSequence : false
				onClicked: context.editSequence()

				Layout.preferredWidth: 60
			}
		}
	}
}
