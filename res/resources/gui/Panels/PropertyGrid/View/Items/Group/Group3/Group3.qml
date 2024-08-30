import QtQuick 2.7
import "../Common"
import "../Group4"
import "../../../Settings.js" as Settings

BaseGroup {
	childrenTopPadding: Settings.group3ChildrenTopMargin
	childrenBottomPadding: Settings.group3ChildrenBottomMargin
	childrenSpacing: Settings.groupItemSpacing
	flexibleHeader: false

	headerDelegate: Group3Header {
		text: model ? model.node.name : ""
	}

	groupDelegate: Group4 {}
}
