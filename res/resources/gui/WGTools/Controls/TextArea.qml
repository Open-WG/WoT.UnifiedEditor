import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details
import WGTools.Controls.impl 1.0 as Impl

T.TextArea {
	id: control

	property bool dirty: false

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		Math.max(placeholder.implicitWidth, contentWidth) + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		Math.max(placeholder.implicitHeight, contentHeight) + topPadding + bottomPadding)

	padding: ControlsSettings.padding
	topPadding: ControlsSettings.smallPadding
	bottomPadding: ControlsSettings.smallPadding
	horizontalAlignment: TextEdit.AlignLeft
	verticalAlignment: TextEdit.AlignTop 
	wrapMode: TextEdit.Wrap

	selectByMouse: true
	selectionColor: _palette.color12
	selectedTextColor: _palette.color1
	color: (enabled && !readOnly) ? _palette.color1 : _palette.color2

	font.family: ControlsSettings.fontFamily
	font.pixelSize: ControlsSettings.textNormalSize
	font.hintingPreference: Font.PreferFullHinting

	Impl.TextInputTuner.alwaysCopyable: true

	Details.TextFieldPlaceholder {
		id: placeholder
	}

	cursorDelegate: Details.CursorDelegate {
		textInput: control
	}

	background: Details.TextFieldBackground {}

	Details.ColorBehavior on color {}
}
