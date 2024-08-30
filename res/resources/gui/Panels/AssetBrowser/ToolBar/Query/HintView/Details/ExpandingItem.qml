import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

RowItem {
	id: root

	property string expandText
	property string collapseText
	property bool expanded
	property real leftMargin

	Misc.IconLabel {
		anchors.fill: parent
		anchors.leftMargin: root.leftMargin

		icon.source: "image://gui/icon-expand-down?color=" + encodeURIComponent(_palette.color2)
		icon.rotation: root.expanded ? 180 : 0
		iconNest.width: 30

		label.text: root.expanded ? root.collapseText : root.expandText
		label.font.bold: true
	}
}
