import QtQuick 2.11
import WGTools.Controls.Details 2.0 as Details
import WGTools.ControlsEx.Details 1.0 as DetailsEx

Details.ComboBoxPopup {
	id: popupView

	Component {
		id: content
		DetailsEx.FilterableComboBoxPopupContent {}
	}

	Component {
		id: emptyContent
		DetailsEx.FilterableComboBoxPopupEmptyContent {}
	}

	contentItem: Loader {
		sourceComponent: control.count > 0 ? content : emptyContent
	}
}
