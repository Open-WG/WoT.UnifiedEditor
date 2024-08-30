import QtQml 2.11
import WGTools.Controls 2.0

MenuItem {
	text: "Add comment"
	visible: context.sequenceModel.commentsEnabled && context.commentsDialogController.addCommentPopupIsVisible()
	onTriggered: {
		Qt.callLater( function() {
			context.commentsDialogController.addCommentToSelectedKeys()
		})
	}
}
