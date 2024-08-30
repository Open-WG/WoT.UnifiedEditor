import QtQuick 2.11
import WGTools.Controls 2.0

Menu {
	property real time
	MenuItem {
		text: "Add Global Comment"
		onTriggered: Qt.callLater(function() { context.commentsDialogController.addGlobalComment(time) })
	}
}
