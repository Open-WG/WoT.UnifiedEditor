import QtQuick 2.11
import WGTools.Templates 1.0 as T
import WGTools.Controls.Details 2.0 as Details
import WGTools.ControlsEx.Details 1.0 as DetailsEx

T.FilterableComboBox {
	id: control

	property var popupModel: filterModel
	property bool highlightEnabled: true

	readonly property bool _indicatorVisible: indicator && indicator.visible

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		contentItem.implicitWidth + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		Math.max(contentItem.implicitHeight,
				 indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)

	baselineOffset: contentItem.y + contentItem.baselineOffset
	spacing: ControlsSettings.spacing
	padding: ControlsSettings.padding
	topPadding: ControlsSettings.smallPadding
	bottomPadding: ControlsSettings.smallPadding
	leftPadding: padding
	rightPadding: indicator.width + separator.width + (clearButton.visible ? clearButton.width : 0) + spacing
	hoverEnabled: true

	font.family: ControlsSettings.fontFamily
	font.pixelSize: ControlsSettings.textNormalSize
	font.hintingPreference: Font.PreferFullHinting

	contentItem: DetailsEx.FilterableComboBoxContent {}
	delegate: DetailsEx.FilterableComboBoxDelegate {}
	popup: DetailsEx.FilterableComboBoxPopup {}
	indicator: DetailsEx.FilterableComboBoxIndicator {down: control.popup.visible}
	background: Details.TextFieldBackground {}

	Details.TextFieldSeparator {
		id: separator
		x: control.indicator.x - width
	}

	Details.BasicIndicatorButton {
		id: clearButton
		Accessible.name: "X"
		width: control.indicator.width
		height: control.height
		x: separator.x - width
		source: "controls-close"
		opacity: control.currentIndex != styleData.clearTextIndex

		onClicked: {
			control.setActive(styleData.clearTextIndex)
		}
	}

	onDisplayTextChanged: {
		contentItem.text = displayText
	}

	onCurrentTextChanged: {
		contentItem.text = currentText
	}

	onHighlightedTextChanged: {
		if (navigatingByKey) {
			contentItem.text = highlightedText
		}
	}

	Details.BackgroundBB {}
	Details.ContentItemBB {}
}
