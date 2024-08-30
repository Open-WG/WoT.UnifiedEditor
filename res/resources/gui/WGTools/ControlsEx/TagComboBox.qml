import QtQuick 2.11
import WGTools.Templates 1.0 as T
import WGTools.Controls.Details 2.0 as Details
import WGTools.ControlsEx.Details 1.0 as DetailsEx

T.TagComboBox {
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
	topPadding: ControlsSettings.smallPadding
	bottomPadding: ControlsSettings.smallPadding
	leftPadding: ControlsSettings.padding
	rightPadding: indicator.width + separator.width + spacing
	hoverEnabled: true

	font.family: ControlsSettings.fontFamily
	font.pixelSize: ControlsSettings.textNormalSize
	font.hintingPreference: Font.PreferFullHinting

	contentItem: DetailsEx.TagComboBoxContent {}
	delegate: DetailsEx.FilterableComboBoxDelegate {
		id: tagDelegate
		icon.source: ""

		TagIcon {
			x: control.spacing
			y: (tagDelegate.height - height) / 2
			text: tagDelegate.text.substring(0, 1)
		}

		onClicked: {
			control.contentItem.text = ""
			control.popup.close()
			setActive(index)
			addTag(currentIndex)
		}
	}
	popup: DetailsEx.FilterableComboBoxPopup {
		onClosed: {
			control.highlightedIndex = -1
		}
	}
	indicator: DetailsEx.FilterableComboBoxIndicator {down: control.popup.visible}
	background: Details.TextFieldBackground {}

	Details.TextFieldSeparator {
		id: separator
		x: control.indicator.x - width
	}

	onDisplayTextChanged: {
		contentItem.text = displayText
		checkTogglePopup()
	}

	onHighlightedTextChanged: {
		if (navigatingByKey) {
			contentItem.text = highlightedText
		}
	}

	function apply() {
		control.addFilteredTags();
		displayText = ""
		checkTogglePopup()
	}

	function checkTogglePopup() {
		// open popup
		if (!control.popup.visible && contentItem.text != "") {
			control.popup.open()
		}

		// close
		if (control.popup.visible && contentItem.text == "") {
			control.popup.close()
		}
	}

	Keys.onEnterPressed: apply()
	Keys.onReturnPressed: apply()

	Details.BackgroundBB {}
	Details.ContentItemBB {}
}
