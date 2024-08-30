import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0
import WGTools.Style 1.0

Rectangle {
	id: control
	property alias text: label.text
	width: ControlsSettings.textNormalSize
	height: width
	color: {
		// https://werxltd.com/wp/2010/05/13/javascript-implementation-of-javas-string-hashcode-method/
		var hash = 0, i, chr
		if (text.length === 0) return _palette.color8
		for (i = 0; i < text.length; i++) {
			chr   = text.charCodeAt(i)
			hash  = ((hash << 5) - hash) + chr
			hash |= 0
		}
		return [_palette.lightRed, _palette.lightOrange, _palette.lightYellow, _palette.lightGreen,
			_palette.lightBlue, _palette.color12, _palette.lightPurple, _palette.lightPink][hash & 7]
	}
	radius: width / 2

	Text {
		id: label
		bottomPadding: ControlsSettings.smallPadding
		color: _palette.color1
		anchors.centerIn: parent
		font.pixelSize: ControlsSettings.textTinySize
		font.capitalization: Font.AllUppercase
		Style.class: "text-bold"
	}
}