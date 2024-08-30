import QtQuick 2.11
import WGTools.Controls.Details 2.0 as Details

Details.ComboBoxDelegate {
	text: model[control.textRole]
	selected: index == control.currentFilterIndex

	onClicked: {
		control.popup.close()
		control.setFilterActive(index)
	}

	onHoveredChanged: {
		if (hovered && !control.navigatingByKey && control.popup.opened) {
			control.highlightedIndex = index
		}
	}
}
