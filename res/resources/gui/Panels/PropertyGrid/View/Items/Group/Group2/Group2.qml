import QtQuick 2.7
import "../Common"
import "../Group3"
import "../../../Settings.js" as Settings

BaseGroup {
	childrenTopPadding: Settings.group2ChildrenTopMargin
	childrenBottomPadding: Settings.group2ChildrenBottomMargin
	childrenSpacing: Settings.groupItemSpacing
	flexibleHeader: false

	headerDelegate: Group2Header {
		text: model ? model.node.name : ""
		actions: model ? model.node.actions : null
	}

	groupDelegate: Group3 {}
}
