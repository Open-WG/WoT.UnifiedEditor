import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import "Buttons"
import "Constants.js" as Constants
import "Helpers.js" as Helpers

Rectangle {
	color: Constants.toolbarBackgroundColor

	implicitHeight: 32

	RowLayout {
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
		anchors.rightMargin: 10

		spacing: 5

		TimelineButton {
			id: focusButton
			Accessible.name: "Focus"

			width: 10
			height: width

			flat: true
			padding: 4

			iconImage: Constants.iconFocus
			iconImageSize.width: 16
			iconImageSize.height: 16

			onClicked: {
				Helpers.focusSequence(context)
			}
		}

		TimelineButton {
			id: feedbackButton
			Accessible.name: "Feedback"

			flat: true
			padding: 4

			iconImage: Constants.iconFeedback
			iconImageSize.width: 16
			iconImageSize.height: 16

			onClicked: {
				context.openFeedbackURL()
			}
		}
	}
}
