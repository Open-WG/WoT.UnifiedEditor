import QtQuick 2.7
import WGTools.Templates 1.0 as T
import WGTools.Controls.Details 2.0 as Details
import WGTools.Controls.impl 1.0 as Impl
import WGTools.Utils 1.0

T.DoubleSpinBox {
	id: control

	property bool dirty: false
	property bool isNonDefault: false
	property bool buttonsVisible: hovered && !activeFocus && editable

	property alias label: label
	property alias unitsLabel: unitsLabel
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
	spacing: 0
	padding: ControlsSettings.padding
	topPadding: ControlsSettings.smallPadding
	bottomPadding: ControlsSettings.smallPadding
	leftPadding: padding
	rightPadding: padding
		+ (__indicatorsWidth > 0 ? __indicatorsWidth + spacing : 0)

	clip: true
	editable: true
	hoverEnabled: true
	wheelEnabled: activeFocus
	buttonsFocusEnabled: false
	focusPolicy: Qt.StrongFocus

	inputMethodHints: Qt.ImhFormattedNumbersOnly

	font {
		family: ControlsSettings.fontFamily
		pixelSize: ControlsSettings.textNormalSize
	}

	validator: Impl.DoubleValidator {
		locale: control.locale.name
		bottom: Math.min(control.from, control.to)
		top: Math.max(control.from, control.to)
		decimals: control.decimals
		notation: DoubleValidator.StandardNotation
	}

	valueFromText: function(text, locale) {
		if (text.slice(-postfixText.length) == postfixText) {
			text = text.slice(0, -postfixText.length)
		}

		try {
			return Number.fromLocaleString(locale, text);
		} catch (e) {
			return value
		}
	}

	textFromValue: function(value, locale, decimals) {
		return Utils.textFromValue(value, locale, decimals) + postfixText
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

	Details.BackgroundBB {}
	Details.ContentItemBB {}
}
