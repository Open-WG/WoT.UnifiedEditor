import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details

T.TextField {
	implicitHeight: contentHeight + topPadding + bottomPadding
	verticalAlignment: Text.AlignVCenter

	autoScroll: control.editable
	inputMethodHints: control.inputMethodHints
	enabled: control.editable
	readOnly: control.down
	validator: control.validator
	color: control.enabled ? _palette.color1 : _palette.color3

	text: control.editable ? control.editText : control.displayText
	placeholderText: control.editable ? control.placeholderText : ""
	wrapMode: TextInput.WordWrap

	selectByMouse: true
	selectionColor: _palette.color12
	selectedTextColor: _palette.color1

	Details.TextFieldPlaceholder {}
	Details.ColorBehavior on color {}
}
