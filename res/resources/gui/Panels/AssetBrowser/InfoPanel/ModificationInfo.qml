import QtQuick 2.7
import WGTools.Styles.Text 1.0 as Text

Column {
	id: root

	property alias title: titleText.text
	property date date
	property alias author: authorText.text

	Text.BaseLabel {
		id: titleText
		width: parent.width
	}

	Text.BaseRegular { // modification time
		width: parent.width
		text: root.date != undefined ? Qt.formatDateTime(root.date, Qt.SystemLocaleLongDate) : ""
	}

	Row {
		width: parent.width
		spacing: 5

		Text.BaseRegular {
			text: "by"
		}

		Text.BaseRegular {
			id: authorText
			width: parent.width - x
		}
	}
}
