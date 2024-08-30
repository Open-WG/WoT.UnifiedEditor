import QtQuick 2.10
import "../../../Common" as Common

Common.TagIcon {
	width: control.icon.width
	height: control.icon.height
	x: control.padding
	y: control.topPadding + (control.availableHeight - height) / 2
	color: control.tagColor
	text: control.tagName
}
