import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details
import WGTools.Controls.impl 1.0 as Impl

T.TextField {
	id: control

	property alias prefix: prefix
	property alias placeholder: placeholder

	property bool dirty: false
	property bool overridden: false
	property real spacing: ControlsSettings.spacing

	readonly property real availableWidth: width - leftPadding - rightPadding
	readonly property real availableHeight: height - topPadding - bottomPadding

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		Math.max(placeholder.implicitWidth, contentWidth) + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		Math.max(placeholder.implicitHeight, contentHeight) + topPadding + bottomPadding)

	padding: ControlsSettings.padding
	topPadding: ControlsSettings.smallPadding
	bottomPadding: ControlsSettings.smallPadding
	leftPadding: padding + (prefix.visible ? prefix.width : 0)
	horizontalAlignment: TextInput.AlignLeft
	verticalAlignment: TextInput.AlignVCenter
	wrapMode: TextInput.Wrap

	selectByMouse: true
	selectionColor: _palette.color12
	selectedTextColor: _palette.color1
	color: (enabled && !readOnly)
		? control.overridden
			? _palette.color11
			: _palette.color1
		: _palette.color2

	font.family: ControlsSettings.fontFamily
	font.pixelSize: ControlsSettings.textNormalSize
	font.hintingPreference: Font.PreferFullHinting

	Impl.TextInputTuner.alwaysCopyable: true

	onActiveFocusChanged: {
		if (!activeFocus) {
			deselect()
		}
	}

	Details.TextFieldPlaceholder {
		id: placeholder
	}

	Details.TextFieldPrefix {
		id: prefix
	}

	cursorDelegate: Details.CursorDelegate {
		textInput: control
	}

	background: Details.TextFieldBackground {}

	Details.ColorBehavior on color {}
	Details.BackgroundBB {}
	Details.ContentItemBB {}
	Details.DecorationsBB {a:prefix}
}
