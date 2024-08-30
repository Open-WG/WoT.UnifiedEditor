import WGTools.Controls 2.0

ContextMenuKeyBase {
	id: contextMenu

	property real time

	MenuItem {
		text: "Add comment"
		visible: context.sequenceModel.commentsEnabled && context.commentsDialogController.addCommentPopupIsVisibleForContainer()
		onTriggered: {
			Qt.callLater(function() {
				context.commentsDialogController.addCommentToContainerKeys(contextMenu.time)
			})
		}
	}
}
