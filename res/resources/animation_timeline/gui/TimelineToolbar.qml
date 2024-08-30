import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import "Buttons"
import "Constants.js" as Constants
import "Helpers.js" as Helpers
import "Debug"

Rectangle {
	property var context: null

	color: Constants.toolbarBackgroundColor

	implicitHeight: 32

	RowLayout {
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
		anchors.rightMargin: 10

		spacing: 5

		TimelineButton {
			id: focusButton

			width: 10
			height: width

			flat: true
			padding: 4

			iconImage: Constants.iconFocus
			iconImageSize.width: 16
			iconImageSize.height: 16

			onClicked: {
				Helpers.focusSequence(timelineContext)
			}
		}

		TimelineButton {
			id: feedbackButton

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
