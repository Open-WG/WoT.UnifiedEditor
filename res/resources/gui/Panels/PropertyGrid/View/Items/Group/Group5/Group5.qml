import QtQuick 2.7
import "../Common"
import "../Group2"
import "../../../Settings.js" as Settings

BaseGroup {
	childrenTopPadding: Settings.group3ChildrenTopMargin
	childrenBottomPadding: Settings.group3ChildrenBottomMargin
	childrenSpacing: Settings.groupItemSpacing
	flexibleHeader: false

	headerDelegate: Group2Header {
		text: model ? model.node.name : ""
		actions: model ? model.node.actions : null
	}
}