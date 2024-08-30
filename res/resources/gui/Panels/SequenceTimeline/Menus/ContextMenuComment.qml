import QtQuick 2.11
import WGTools.Controls 2.0

Menu {
	MenuItem {
		text: commentData.compact ? "Expande Comment" : "Collapse Comment"
		onTriggered: {
			commentData.compact = !commentData.compact
		}
	}

	MenuItem {
		text: "Change Comment"
		onTriggered: {
			Qt.callLater(function() {
				context.commentsDialogController.changeComment(commentData)
			})
		}
	}

	MenuItem {
		text: "Remove Comment"
		onTriggered: {
			Qt.callLater(function() {
				context.commentsDialogController.removeComment(commentData)
			})
		}
	}
}
