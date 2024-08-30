import QtQuick 2.11
import WGTools.Controls.Details 2.0
import WGTools.ControlsEx.Details 1.0 as Details
import WGTools.Templates 1.0 as T

T.FiltersView {
	id: control

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		(contentItem ? contentItem.implicitWidth : 0) + padding*2)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		Math.max(
			contentItem ? contentItem.implicitHeight : 0,
			indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)

	padding: ControlsSettings.padding
	spacing: ControlsSettings.spacing
	textRole: "display"

	delegate: Details.FiltersViewDelegate {}
	contentItem: Details.FiltersViewContent {}
	background: Details.FiltersViewBackground {}
	indicator: Details.FiltersViewIndicator {}
	popup: Details.FiltersViewPopup {}
	collectionDelegate: Details.FiltersViewCollectionDelegate {}
}
