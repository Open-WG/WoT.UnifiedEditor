import QtQuick 2.11
import WGTools.Controls.Details 2.0
import WGTools.Controls.impl 1.0 as Impl

TextInput {
	id: spinBoxContent
	leftPadding: control.label.width > 0 ? control.label.width + control.spacing : 0
	text: control.hasOwnProperty("displayText")
		? control.displayText
		: control.textFromValue(control.value, control.locale, control.decimals)
	z: 2

	horizontalAlignment: TextInput.AlignLeft
	verticalAlignment: TextInput.AlignVCenter

	color: control.dirty
		? _palette.color1
		: control.overridden
			? _palette.color11
			: _palette.color2
	selectionColor: _palette.color12
	selectedTextColor: _palette.color1
	selectByMouse: true
	clip: true

	readOnly: !control.editable
	validator: control.validator
	inputMethodHints: control.inputMethodHints
	font: control.font

	Binding on focus { value: control.activeFocus }

	Impl.TextInputTuner.alwaysCopyable: true
	// Impl.TextInputTuner.ignoreUndo: !spinBoxContent.canUndo

	cursorDelegate: CursorDelegate {
		textInput: spinBoxContent
	}

	Connections {
		target: control
		ignoreUnknownSignals: true

		onActiveFocusChanged: {
			if (activeFocus && focusReason != Qt.MouseFocusReason) {
				selectAll()
				return
			}
		}
	}

	onWidthChanged: {
		ensureVisible(0)
	}
}
