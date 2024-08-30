import QtQuick 2.7
import WGTools.Styles.Text 1.0 as Text

Column {
	property alias title: titleText.text
	property alias text: infoText.text

	Text.BaseLabel {
		id: titleText
		width: parent.width
	}

	Text.BaseRegular {
		id: infoText
		width: parent.width
	}
}
