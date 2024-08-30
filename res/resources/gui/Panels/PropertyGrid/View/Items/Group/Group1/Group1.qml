import QtQuick 2.10
import WGTools.Misc 1.0 as Misc
import "../Common"
import "../Group2"
import "../../../Settings.js" as Settings

BaseGroup {
	childrenTopPadding: Settings.group1ChildrenTopMargin
	childrenBottomPadding: Settings.group1ChildrenBottomMargin

	headerDelegate: Group1Header {
		text: model ? model.node.name : ""
		actions: model ? model.node.actions : null
	}

	groupDelegate: Group2 {}
}
