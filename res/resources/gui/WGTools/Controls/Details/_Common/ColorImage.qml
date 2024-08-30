import QtQuick 2.11
import WGTools.Controls.Details 2.0

Image {
	property string src
	property color color: _palette.color2

	Binding on source {
		value: "image://gui/" + src + "?color=" + encodeURIComponent(color)
	}

	ColorBehavior on color {}
}
