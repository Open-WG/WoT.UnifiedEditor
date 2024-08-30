import QtQuick 2.7
import "../../../../Common" as Common

Common.ClosableDelegateWrapper {
	id: wrapper
	height: parent.height
	color: _palette.color5

	Common.TagItem {
		height: parent.height
		rightPadding: wrapper.closable ? 0 : spacing
		iconColor: model.decoration
		text: model.display
	}
}
