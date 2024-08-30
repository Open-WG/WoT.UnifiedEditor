import QtQuick 2.7
import WGTools.Controls.Details 2.0 as Details

Details.ComboBoxPopupContent {
	delegate: control.delegate
	model: control.popup.visible ? control.popupModel : null;

	Connections {
		target: control
		
		onHighlightedIndexChanged: {
			if (control.navigatingByKey) {
				positionViewAtIndex(control.highlightedIndex, ListView.Contain)
			}
		}
	}
}
