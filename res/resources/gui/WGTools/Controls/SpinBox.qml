import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details

T.SpinBox {
	id: control

	property bool dirty: false
	property bool overridden: false
	property bool buttonsVisible: hovered && !activeFocus

	property alias label: label
	property string postfixText: ""
	property string units: ""

	readonly property bool upVisible: up.indicator && up.indicator.visible
	readonly property bool downVisible: down.indicator && down.indicator.visible

	readonly property real __buttonsWidth: Math.max(
		up.indicator ? up.indicator.implicitWidth : 0,
		down.indicator ? down.indicator.implicitWidth : 0)

	readonly property real __visibleButtonsWidth: Math.max(
		upVisible ? up.indicator.implicitWidth : 0,
		downVisible ? down.indicator.implicitWidth : 0)

	readonly property real __indicatorsWidth: Math.max(
		__visibleButtonsWidth,
		unitsLabel.visible ? unitsLabel.width : 0)

	readonly property real __indicatorsHeight: (
		(upVisible ? up.indicator.implicitHeight : 0) +
		(downVisible ? down.indicator.implicitHeight : 0))

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		contentItem.implicitWidth + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		contentItem.implicitHeight + topPadding + bottomPadding,
		__indicatorsHeight)

	baselineOffset: contentItem.y + contentItem.baselineOffset
	spacing: ControlsSettings.spacing
	padding: ControlsSettings.padding
	topPadding: ControlsSettings.smallPadding
	bottomPadding: ControlsSettings.smallPadding
	rightPadding: padding
		+ (__indicatorsWidth > 0 ? __indicatorsWidth + spacing : 0)
		+ (separator.visible ? separator.width + spacing : 0)

	hoverEnabled: true
	wheelEnabled: activeFocus

	inputMethodHints: Qt.ImhFormattedNumbersOnly

	font.family: ControlsSettings.fontFamily
	font.pixelSize: ControlsSettings.textNormalSize

	validator: IntValidator {
		locale: control.locale.name
		bottom: Math.min(control.from, control.to)
		top: Math.max(control.from, control.to)
	}

	valueFromText: function(text, locale) {
		if (text.slice(-postfixText.length) == postfixText) {
			text = text.slice(0, -postfixText.length)
		}

		return Number.fromLocaleString(locale, text);
	}

	textFromValue: function(value, locale) {
		return Number(value).toLocaleString(locale, 'f', 0) + postfixText
	}

	contentItem: Details.SpinBoxContent {}
	background: Details.SpinBoxBackground {}

	up.indicator: Details.SpinButtonUp {}
	down.indicator: Details.SpinButtonDown {}

	Details.SpinBoxLabel {
		id: label
	}

	Details.SpinBoxUnitsLabel {
		id: unitsLabel
	}

	Details.SpinBoxSeparator {
		id: separator
	}

	Details.BackgroundBB {}
	Details.ContentItemBB {}
}
