import QtQuick 2.11
import WGTools.Views.Details 1.0
import WGTools.Controls.impl 1.0

StandardItemDelegate {
	icon.source: "image://gui/icon-folder"
	ActiveFocus.when: styleData.index == view.currentIndex
}
