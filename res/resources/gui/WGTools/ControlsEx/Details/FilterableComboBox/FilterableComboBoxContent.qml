import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details

T.TextField {
	Accessible.name: "Text"
	implicitHeight: contentHeight + topPadding + bottomPadding
	verticalAlignment: Text.AlignVCenter

	autoScroll: control.editable
	color: control.enabled ? _palette.color1 : _palette.color3
	enabled: control.enabled
	readOnly: !control.editable
	focus: true
	wrapMode: TextEdit.WordWrap

	selectByMouse: true
	selectionColor: _palette.color12
	selectedTextColor: _palette.color1

	onTextEdited: {
		control.displayText = text
		control.filterModel.filterTokens = text
	}

	Details.ColorBehavior on color {}
}
