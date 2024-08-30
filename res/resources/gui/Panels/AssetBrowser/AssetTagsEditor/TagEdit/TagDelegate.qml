import QtQuick 2.10
import "../../Common" as Common

Common.ClosableDelegateWrapper {
	color: _palette.color5
	closable: model.ownTag

	Common.TagItem {
		rightPadding: parent.closable ? 0 : spacing
		text: model.tagName
		iconColor: model.tagColor
	}
}